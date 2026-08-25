<#
.SYNOPSIS
Executable release gate for one publish-ready article package.

.DESCRIPTION
Blocks FINAL naming when objective evidence is missing or when Markdown and
the release DOCX diverge. This does not replace the human R1-R5 review.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$PackagePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$findings = [System.Collections.Generic.List[string]]::new()

function Add-Finding([string]$Code, [string]$Message) {
    $script:findings.Add("$Code — $Message")
}

function Get-FileText([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        Add-Finding 'P0_FILE_MISSING' (Split-Path -Leaf $Path)
        return ''
    }
    return Get-Content -LiteralPath $Path -Raw -Encoding UTF8
}

function Get-ZipEntryText([string]$DocxPath, [string]$EntryName) {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [System.IO.Compression.ZipFile]::OpenRead($DocxPath)
    try {
        $entry = $archive.GetEntry($EntryName)
        if ($null -eq $entry) { throw "DOCX entry missing: $EntryName" }
        $reader = [System.IO.StreamReader]::new($entry.Open())
        try { return $reader.ReadToEnd() } finally { $reader.Dispose() }
    } finally { $archive.Dispose() }
}

function Get-MarkdownTableBlockCount([string]$Markdown) {
    $count = 0; $inside = $false
    foreach ($line in ($Markdown -split "`r?`n")) {
        if ($line.Trim().StartsWith('|')) {
            if (-not $inside) { $count++; $inside = $true }
        } else { $inside = $false }
    }
    return $count
}

function Get-NarrativeWordCount([string]$Markdown) {
    $lines = [System.Collections.Generic.List[string]]::new()
    $sources = $false
    foreach ($line in ($Markdown -split "`r?`n")) {
        if ($line -match '^##\s+Sources\s*$') { $sources = $true; continue }
        if ($sources -or $line.Trim().StartsWith('|') -or $line.Trim().StartsWith('![')) { continue }
        if ($line -match '^\*\*(SEO title|Meta description|Slug):') { continue }
        $lines.Add($line)
    }
    $plain = ($lines -join "`n") -replace '[#*_`\[\]\(\)]', ' '
    return ([regex]::Matches($plain, "[A-Za-z0-9]+(?:['’-][A-Za-z0-9]+)?")).Count
}

function Get-NormalizedHeadingText([string]$Text) {
    return (($Text -replace '\s+', ' ').Trim()).ToLowerInvariant()
}

function Test-HeadingLevelSequence([object[]]$Headings, [string]$Origin) {
    if ($Headings.Count -eq 0) {
        Add-Finding "P0_${Origin}_HEADING_MISSING" "$Origin has no semantic headings."
        return
    }
    for ($i = 1; $i -lt $Headings.Count; $i++) {
        if ([int]$Headings[$i].Level -gt ([int]$Headings[$i - 1].Level + 1)) {
            Add-Finding "P0_${Origin}_HEADING_JUMP" "$Origin skips from H$($Headings[$i - 1].Level) to H$($Headings[$i].Level): $($Headings[$i].Text)"
            break
        }
    }
}

$resolved = Resolve-Path -LiteralPath $PackagePath -ErrorAction SilentlyContinue
if ($null -eq $resolved -or -not (Test-Path -LiteralPath $PackagePath -PathType Container)) {
    Write-Error "Package directory does not exist: $PackagePath"
    exit 2
}
$root = $resolved.Path
$index = Get-FileText (Join-Path $root '00_最终交付包索引.md')
$serp = Get-FileText (Join-Path $root '03_SERP与竞品分析.md')
$brief = Get-FileText (Join-Path $root '04_Content_Brief.md')
$map = Get-FileText (Join-Path $root '05_文章结构与关键词映射.md')
$markdown = Get-FileText (Join-Path $root '06_完整文章.md')
$docx = Join-Path $root '06_完整文章.docx'
$visual = Get-FileText (Join-Path $root '07_视觉资产与映射表.md')
$qa = Get-FileText (Join-Path $root '11_标准回审与质量报告.md')
$preservation = Get-FileText (Join-Path $root '13_内容资产保留审计.md')
$delivery = Get-FileText (Join-Path $root '14_终稿交付清单.md')
$renderPath = Join-Path $root 'qa-render.json'

if (-not (Test-Path -LiteralPath $docx -PathType Leaf)) { Add-Finding 'P0_FILE_MISSING' '06_完整文章.docx' }

# Gate 1: auditable SERP.
foreach ($column in @('Natural rank', 'Title', 'URL', 'Page type')) {
    if ($serp -notmatch [regex]::Escape($column)) { Add-Finding 'P0_SERP_SCHEMA' "03_SERP与竞品分析.md lacks column: $column" }
}
$rankRows = ([regex]::Matches($serp, '(?m)^\|\s*(?:[1-9]|10)\s*\|')).Count
if ($rankRows -lt 10) { Add-Finding 'P0_SERP_TOP10' "Natural SERP rows found: $rankRows; required: 10" }
if ($serp -match '(?im)Capture order' -and $serp -notmatch '(?im)Natural rank') { Add-Finding 'P0_SERP_RANK' 'Capture order cannot substitute for natural rank.' }

# Gate 2: product conflict must be explicitly resolved by the user.
$product = [regex]::Match($brief, '(?im)^Recommended product supplied:\s*(.+?)\s*$')
$decision = [regex]::Match($brief, '(?im)^Product decision:\s*(formal_method|ultra_tip|excluded)\s*$')
$resolution = [regex]::Match($brief, '(?im)^Product-resolution status:\s*(not_needed|user_confirmed|blocked_waiting_for_user)\s*$')
if (-not $product.Success -or -not $decision.Success -or -not $resolution.Success) {
    Add-Finding 'P0_PRODUCT_RECORD' 'Brief lacks the required product decision/resolution fields.'
} elseif ($product.Groups[1].Value.Trim() -notmatch '^(none|无)$' -and $decision.Groups[1].Value -eq 'excluded' -and $resolution.Groups[1].Value -ne 'user_confirmed') {
    Add-Finding 'P0_PRODUCT_CONFLICT' 'User-supplied product was excluded without recorded user confirmation.'
}

# Gate 3: validated length and primary keyword coverage.
$narrativeCount = Get-NarrativeWordCount $markdown
$range = [regex]::Match($brief, '(?im)^Validated target word range:\s*([0-9,]+)\s*[–-]\s*([0-9,]+)')
if (-not $range.Success) {
    Add-Finding 'P0_WORD_RANGE' 'Brief lacks a validated target word range.'
} else {
    $minimum = [int]($range.Groups[1].Value -replace ',', '')
    if ($narrativeCount -lt $minimum) { Add-Finding 'P0_WORD_COUNT' "Narrative word count $narrativeCount is below validated minimum $minimum." }
    $reported = [regex]::Match($brief, '(?im)^Validated narrative word count:\s*([0-9,]+)')
    if (-not $reported.Success -or [int]($reported.Groups[1].Value -replace ',', '') -ne $narrativeCount) { Add-Finding 'P0_WORD_COUNT_RECORD' "Brief must record the current computed narrative count ($narrativeCount)." }
}

# Review-final safeguard: preserve an existing article unless the user approved a rewrite.
$reviewMode = [regex]::Match($preservation, '(?im)^Review mode:\s*(optimization|rewrite|new_article)\s*$')
if (-not $reviewMode.Success) {
    Add-Finding 'P0_REVIEW_MODE' '13_内容资产保留审计.md lacks a valid Review mode.'
} elseif ($reviewMode.Groups[1].Value -eq 'optimization') {
    $sourceWords = [regex]::Match($preservation, '(?im)^Source narrative word count:\s*([0-9,]+)\s*$')
    $retention = [regex]::Match($preservation, '(?im)^Effective-information retention:\s*([0-9.]+)%\s*$')
    $reductionApproval = [regex]::Match($preservation, '(?im)^User-approved structural reduction:\s*(yes|no|not_needed)\s*$')
    $ledgerRows = ([regex]::Matches($preservation, '(?m)^\|\s*[^|]+\|\s*[^|]+\|\s*[^|]+\|\s*(?:保留|优化|新增|删除|替换|retain|improve|add|delete|replace)')).Count
    if (-not $sourceWords.Success -or -not $retention.Success -or -not $reductionApproval.Success -or $ledgerRows -lt 1) {
        Add-Finding 'P0_PRESERVATION_AUDIT' 'Optimization mode requires source word count, retention %, reduction approval, and an asset ledger.'
    } else {
        $sourceCount = [int]($sourceWords.Groups[1].Value -replace ',', '')
        if (([double]$retention.Groups[1].Value) -lt 80) { Add-Finding 'P0_INFORMATION_RETENTION' 'Effective-information retention is below 80%.' }
        if ($narrativeCount -lt ($sourceCount * 0.70) -and $reductionApproval.Groups[1].Value -ne 'yes') { Add-Finding 'P0_UNAPPROVED_COMPRESSION' "Final narrative word count $narrativeCount is more than 30% below source $sourceCount without user approval." }
    }
} elseif ($reviewMode.Groups[1].Value -eq 'rewrite' -and $preservation -notmatch '(?im)^User-approved rewrite:\s*yes\s*$') {
    Add-Finding 'P0_REWRITE_APPROVAL' 'Rewrite mode requires recorded user approval.'
}

$primary = [regex]::Match($index, '(?im)^Primary keyword:\s*(.+?)\s*$')
if (-not $primary.Success) {
    Add-Finding 'P0_PRIMARY_KEYWORD' 'Index lacks a machine-readable Primary keyword line.'
} else {
    $keyword = $primary.Groups[1].Value.Trim()
    $body = ($markdown -split '(?im)^##\s+Sources\s*$')[0]
    $body = $body -replace '(?m)^\*\*(SEO title|Meta description|Slug):.*$', ''
    $occurrences = ([regex]::Matches($body, [regex]::Escape($keyword), [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)).Count
    if ($occurrences -lt 1) { Add-Finding 'P0_PRIMARY_KEYWORD_MISSING' "Primary keyword '$keyword' has no natural body occurrence." }
    $h1 = [regex]::Match($markdown, '(?m)^#\s+(.+)$')
    if (-not $h1.Success -or $h1.Groups[1].Value -notmatch [regex]::Escape($keyword)) { Add-Finding 'P0_PRIMARY_KEYWORD_H1' "Primary keyword '$keyword' is missing from H1." }
    $quickAnswer = [regex]::Match($body, '(?ims)^##\s+Quick answer\s*$.*?(?=^##\s+|\z)')
    if (-not $quickAnswer.Success -or $quickAnswer.Value -notmatch [regex]::Escape($keyword)) { Add-Finding 'P0_PRIMARY_KEYWORD_QUICK_ANSWER' "Primary keyword '$keyword' is missing from Quick Answer." }
    $mapLine = [regex]::Match($map, "(?im)^\|\s*$([regex]::Escape($keyword))\s*\|.*$")
    if (-not $mapLine.Success -or $mapLine.Value -notmatch '\|\s*Covered\s*\|\s*$') { Add-Finding 'P0_KEYWORD_MAP' "Primary keyword '$keyword' is not recorded as Covered in the Keyword Map." }
}

if ($markdown -match '(?i)\bsearch for\b|\bif you are looking for\b') { Add-Finding 'P0_KEYWORD_STUFFING' 'Article contains a prohibited keyword-stuffing phrase.' }
foreach ($field in @('Method hierarchy review: Pass', 'Best-for scenario audit: Pass', 'Product-position review: Pass', 'Keyword distribution review: Pass')) {
    if ($map -notmatch [regex]::Escape($field)) { Add-Finding 'P0_METHOD_OR_KEYWORD_REVIEW' "Keyword/structure record lacks: $field" }
}
$methodCount = ([regex]::Matches($markdown, '(?m)^##\s+(?:Method\s+)?\d+[\.:]')).Count
if ($methodCount -gt 0 -and ([regex]::Matches($markdown, '(?i)\*\*Best for:\*\*')).Count -lt $methodCount) { Add-Finding 'P0_BEST_FOR_COVERAGE' "Methods: $methodCount; Best for blocks: $(([regex]::Matches($markdown, '(?i)\*\*Best for:\*\*')).Count)." }

$highRows = @(); $highExcluded = 0
foreach ($line in ($map -split "`r?`n")) {
    if ($line -notmatch '^\| ' -or $line -match '^\| (Keyword|---)') { continue }
    $cells = @($line.Trim('|').Split('|') | ForEach-Object { $_.Trim() })
    if ($cells.Count -ge 6 -and $cells[2] -eq 'High') {
        $highRows += $line
        if ($cells[-1] -match 'Manual Review / Excluded') { $highExcluded++ }
    }
}
if ($highRows.Count -gt 0 -and ($highExcluded / $highRows.Count) -gt 0.20) { Add-Finding 'P0_KEYWORD_BULK_EXCLUSION' "High-priority keyword exclusions: $highExcluded/$($highRows.Count), above the 20% review threshold." }

# Gate 4: release DOCX must represent Markdown, not raw Markdown syntax.
if (Test-Path -LiteralPath $docx -PathType Leaf) {
    $docXml = Get-ZipEntryText $docx 'word/document.xml'

    # Semantic heading parity: the release DOCX is the publishable artifact, so
    # correct Markdown headings are insufficient if the conversion changes their Word styles.
    $markdownHeadings = [System.Collections.Generic.List[object]]::new()
    foreach ($match in [regex]::Matches($markdown, '(?m)^(#{1,6})\s+(.+?)\s*$')) {
        $markdownHeadings.Add([pscustomobject]@{
            Level = $match.Groups[1].Value.Length
            Text = $match.Groups[2].Value.Trim()
            NormalizedText = Get-NormalizedHeadingText $match.Groups[2].Value
        })
    }
    $markdownH1Count = @($markdownHeadings | Where-Object { $_.Level -eq 1 }).Count
    if ($markdownH1Count -ne 1) { Add-Finding 'P0_MARKDOWN_H1_COUNT' "Markdown H1 count: $markdownH1Count; required: exactly 1." }
    Test-HeadingLevelSequence @($markdownHeadings) 'MARKDOWN'

    try {
        [xml]$docXmlDom = $docXml
        $wordNsUri = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
        $wordNs = [System.Xml.XmlNamespaceManager]::new($docXmlDom.NameTable)
        $wordNs.AddNamespace('w', $wordNsUri)
        $docxHeadings = [System.Collections.Generic.List[object]]::new()
        foreach ($paragraph in $docXmlDom.SelectNodes('//w:body/w:p[w:pPr/w:pStyle]', $wordNs)) {
            $styleNode = $paragraph.SelectSingleNode('./w:pPr/w:pStyle', $wordNs)
            $style = $styleNode.GetAttribute('val', $wordNsUri)
            if ($style -notmatch '^Heading\s*([1-9])$') { continue }
            $text = (($paragraph.SelectNodes('.//w:t', $wordNs) | ForEach-Object { $_.InnerText }) -join '')
            $docxHeadings.Add([pscustomobject]@{
                Level = [int]$Matches[1]
                Text = $text.Trim()
                NormalizedText = Get-NormalizedHeadingText $text
            })
        }
        $docxH1Count = @($docxHeadings | Where-Object { $_.Level -eq 1 }).Count
        if ($docxH1Count -ne 1) { Add-Finding 'P0_DOCX_H1_COUNT' "Release DOCX Heading 1 count: $docxH1Count; required: exactly 1." }
        Test-HeadingLevelSequence @($docxHeadings) 'DOCX'

        if ($docxHeadings.Count -ne $markdownHeadings.Count) {
            Add-Finding 'P0_DOCX_HEADING_PARITY' "Markdown semantic headings: $($markdownHeadings.Count); DOCX semantic headings: $($docxHeadings.Count)."
        } else {
            for ($i = 0; $i -lt $markdownHeadings.Count; $i++) {
                $expected = $markdownHeadings[$i]
                $actual = $docxHeadings[$i]
                if ($actual.Level -ne $expected.Level -or $actual.NormalizedText -ne $expected.NormalizedText) {
                    Add-Finding 'P0_DOCX_HEADING_PARITY' "Heading $($i + 1) mismatch. Markdown: H$($expected.Level) '$($expected.Text)'; DOCX: H$($actual.Level) '$($actual.Text)'."
                    break
                }
            }
        }
        if ($markdownH1Count -eq 1 -and $docxH1Count -eq 1 -and $docxHeadings.Count -gt 0 -and $docxHeadings[0].NormalizedText -ne $markdownHeadings[0].NormalizedText) {
            Add-Finding 'P0_DOCX_PRIMARY_HEADING' "Release DOCX Heading 1 must be the Markdown H1: '$($markdownHeadings[0].Text)'."
        }
    } catch {
        Add-Finding 'P0_DOCX_HEADING_AUDIT' 'Release DOCX heading styles could not be parsed and verified.'
    }

    $markdownTables = Get-MarkdownTableBlockCount $markdown
    $docTables = ([regex]::Matches($docXml, '<w:tbl>')).Count
    if ($docTables -lt $markdownTables) { Add-Finding 'P0_DOCX_TABLE_PARITY' "Markdown table blocks: $markdownTables; Word tables: $docTables." }
    foreach ($token in @('**', '![', '](', '`')) {
        if ($docXml.Contains($token)) { Add-Finding 'P0_DOCX_RAW_MARKDOWN' "Release DOCX contains raw Markdown token: $token" }
    }
    $docPr = [regex]::Matches($docXml, '<wp:docPr\b[^>]*/>')
    foreach ($node in $docPr) {
        if ($node.Value -notmatch '\bdescr="[^"]+"') { Add-Finding 'P0_DOCX_ALT_TEXT' 'At least one release-DOCX image has no alt text.'; break }
    }

    # Visual delivery: one scenario overview plus one visual for each numbered method.
    $expectedVisuals = if ($methodCount -gt 0) { $methodCount + 1 } else { 1 }
    $assetPaths = @([regex]::Matches($visual, '`(assets/[^`]+)`') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique)
    if ($assetPaths.Count -lt $expectedVisuals) { Add-Finding 'P0_VISUAL_COVERAGE' "Mapped visual assets: $($assetPaths.Count); required minimum: $expectedVisuals." }
    foreach ($assetPath in $assetPaths) {
        if (-not (Test-Path -LiteralPath (Join-Path $root $assetPath) -PathType Leaf)) { Add-Finding 'P0_VISUAL_ASSET_MISSING' "Mapped asset not found: $assetPath" }
    }
    if ($docPr.Count -lt $expectedVisuals) { Add-Finding 'P0_DOCX_VISUAL_EMBED' "DOCX embedded images: $($docPr.Count); required minimum: $expectedVisuals." }
    if ($visual -notmatch '(?im)(Embedded in Word|Word embedded status)') { Add-Finding 'P0_VISUAL_MAPPING' 'Visual map lacks an explicit Word-embedded status.' }

    if ($delivery -notmatch '(?im)^Primary deliverable:\s*06_完整文章\.docx\s*$' -or $delivery -notmatch '(?im)^SEO metadata in Word:\s*Pass\s*$' -or $delivery -notmatch '(?im)^DOCX/Markdown equivalence:\s*Pass\s*$') {
        Add-Finding 'P0_FINAL_DELIVERY_MANIFEST' '14_终稿交付清单.md lacks required primary-deliverable/SEO/equivalence Pass records.'
    }
    $visibility = [regex]::Match($delivery, '(?im)^Keyword visibility:\s*(not_requested|report_only|yellow_highlight)\s*$')
    if (-not $visibility.Success) {
        Add-Finding 'P0_KEYWORD_DELIVERY' 'Final delivery manifest lacks Keyword visibility.'
    } elseif ($visibility.Groups[1].Value -eq 'yellow_highlight' -and $docXml -notmatch '<w:highlight\s+w:val="yellow"') {
        Add-Finding 'P0_KEYWORD_HIGHLIGHT' 'Yellow keyword highlighting was requested but is absent from the DOCX.'
    } elseif ($visibility.Groups[1].Value -eq 'report_only' -and $delivery -notmatch '(?im)^Keyword report location:\s*(?!not_requested\s*$).+') {
        Add-Finding 'P0_KEYWORD_REPORT' 'Keyword report was requested but no delivery location is recorded.'
    }
    $sourceSection = ($markdown -split '(?im)^##\s+Sources\s*$')[-1]
    $markdownSources = ([regex]::Matches($sourceSection, '\]\(https?://')).Count
    $docLinks = ([regex]::Matches($docXml, '<w:hyperlink\b')).Count
    if ($docLinks -lt $markdownSources) { Add-Finding 'P0_DOCX_SOURCE_LINKS' "Markdown sources: $markdownSources; Word hyperlinks: $docLinks." }

    # Gate 5: render evidence must hash-match this exact release DOCX.
    if (-not (Test-Path -LiteralPath $renderPath -PathType Leaf)) {
        Add-Finding 'P0_RENDER_EVIDENCE' 'qa-render.json is missing.'
    } else {
        try {
        try { $render = Get-Content -LiteralPath $renderPath -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $render = $null }
        $hash = (Get-FileHash -LiteralPath $docx -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($null -eq $render -or $render.status -ne 'pass' -or $render.source_docx_sha256.ToLowerInvariant() -ne $hash -or [int]$render.page_count -lt 1 -or [string]::IsNullOrWhiteSpace($render.reviewed_by) -or [string]::IsNullOrWhiteSpace($render.inspection)) {
            Add-Finding 'P0_RENDER_EVIDENCE' 'Render evidence is absent, failed, incomplete, or does not match 06_完整文章.docx.'
        } else {
            $pages = @($render.page_files)
            if ($pages.Count -ne [int]$render.page_count) {
                Add-Finding 'P0_RENDER_PAGE_COUNT' "Render manifest pages: $($pages.Count); declared page count: $($render.page_count)."
            }
            foreach ($page in $pages) {
                if ($page -is [string]) {
                    Add-Finding 'P0_RENDER_PAGE_HASH' 'Each qa-render.json page_files entry must contain path and sha256.'
                    break
                }
                $pagePath = [string]$page.path
                $pageHash = [string]$page.sha256
                $absolutePage = Join-Path $root $pagePath
                if ([string]::IsNullOrWhiteSpace($pagePath) -or [string]::IsNullOrWhiteSpace($pageHash) -or -not (Test-Path -LiteralPath $absolutePage -PathType Leaf)) {
                    Add-Finding 'P0_RENDER_PAGE_FILE' "Rendered page evidence is missing: $pagePath"
                } elseif ((Get-FileHash -LiteralPath $absolutePage -Algorithm SHA256).Hash.ToLowerInvariant() -ne $pageHash.ToLowerInvariant()) {
                    Add-Finding 'P0_RENDER_PAGE_HASH' "Rendered page hash mismatch: $pagePath"
                }
            }
        }
        } catch {
            Add-Finding 'P0_RENDER_EVIDENCE' 'Render evidence could not be validated.'
        }
    }
}

if ($qa -notmatch '(?im)^Final status:\s*\*\*Publish Ready\*\*') { Add-Finding 'P0_QA_FINAL_STATUS' 'QA does not record the only releasable status: Publish Ready.' }
if ($qa -match '(?im)^Final status:.*\b(Blocked|Fail)\b|^\|[^|\r\n]*\|\s*(Blocked|Fail)\b|^\s*(Status|Result):\s*(Blocked|Fail)\b|未通过|阻断') { Add-Finding 'P0_QA_BLOCKER' 'QA contains a failure or blocked marker.' }
if ($qa -notmatch [regex]::Escape('Visual coverage review: Pass')) { Add-Finding 'P0_VISUAL_REVIEW' 'QA lacks a passing Visual coverage review.' }
if ($qa -notmatch [regex]::Escape('Visual scenario-quality review: Pass')) { Add-Finding 'P0_VISUAL_SCENARIO_REVIEW' 'QA lacks a passing Visual scenario-quality review.' }
if ($reviewMode.Success -and $reviewMode.Groups[1].Value -eq 'optimization' -and $qa -notmatch [regex]::Escape('Original-asset preservation review: Pass')) { Add-Finding 'P0_ORIGINAL_ASSET_REVIEW' 'Optimization QA lacks a passing Original-asset preservation review.' }
if ($reviewMode.Success -and $reviewMode.Groups[1].Value -eq 'new_article' -and $qa -notmatch '(?i)Original-asset preservation review:\s*not_applicable') { Add-Finding 'P0_ORIGINAL_ASSET_REVIEW' 'New article QA must explicitly mark original-asset preservation as not_applicable.' }

if ($findings.Count -gt 0) {
    Write-Output 'BLOCKED — Not Publish Ready'
    Write-Output 'Release-gate findings:'
    $findings | ForEach-Object { Write-Output "- $_" }
    exit 1
}

Write-Output 'PASS — Publish Ready'
Write-Output 'Objective release checks passed. Confirm the human R1-R5 review is also recorded before external publication.'
exit 0
