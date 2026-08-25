<#
.SYNOPSIS
Read-only preflight check for a single publish-ready article package.

.EXAMPLE
.\tools\Test-PublishReadyPackage.ps1 -PackagePath .\outputs\2026-SEO-001
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$PackagePath
)

$requiredFiles = @(
    '00_最终交付包索引.md',
    '01_节点产出与状态总表.md',
    '02_关键词与搜索意图分析.md',
    '03_SERP与竞品分析.md',
    '04_Content_Brief.md',
    '05_文章结构与关键词映射.md',
    '06_完整文章.md',
    '06_完整文章.docx',
    '07_视觉资产与映射表.md',
    '08_SEO发布信息.md',
    '09_事实与来源核验表.md',
    '10_完整流程执行报告.md',
    '11_标准回审与质量报告.md',
    '12_版本与修改记录.md',
    '13_内容资产保留审计.md',
    '14_终稿交付清单.md',
    'qa-render.json'
)

$resolvedPackage = Resolve-Path -LiteralPath $PackagePath -ErrorAction SilentlyContinue
if ($null -eq $resolvedPackage -or -not (Test-Path -LiteralPath $PackagePath -PathType Container)) {
    Write-Error "Package directory does not exist: $PackagePath"
    exit 2
}

$missing = foreach ($relativeFile in $requiredFiles) {
    $candidate = Join-Path -Path $resolvedPackage.Path -ChildPath $relativeFile
    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        $relativeFile
    }
}

$assetsPath = Join-Path -Path $resolvedPackage.Path -ChildPath 'assets'
if (-not (Test-Path -LiteralPath $assetsPath -PathType Container)) {
    $missing += 'assets/ directory'
}

if ($missing.Count -gt 0) {
    Write-Output 'BLOCKED — Not Publish Ready'
    Write-Output 'Missing required delivery items:'
    $missing | ForEach-Object { Write-Output "- $_" }
    exit 1
}

$releaseGate = Join-Path -Path $PSScriptRoot -ChildPath 'Test-ArticlePublishReady.ps1'
if (-not (Test-Path -LiteralPath $releaseGate -PathType Leaf)) {
    Write-Output 'BLOCKED — Not Publish Ready'
    Write-Output 'Missing executable release gate: tools/Test-ArticlePublishReady.ps1'
    exit 1
}

Write-Output 'Package file preflight passed. Running executable article release gate...'
& $releaseGate -PackagePath $resolvedPackage.Path
exit $LASTEXITCODE
