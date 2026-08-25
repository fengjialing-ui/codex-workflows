[CmdletBinding()]
param(
    [switch]$RequirePublishReady
)

$ErrorActionPreference = 'Stop'
$findings = New-Object System.Collections.Generic.List[string]

function Add-Finding([string]$code, [string]$message) {
    $script:findings.Add("$code — $message")
}

$root = Split-Path -Parent $PSScriptRoot
foreach ($relative in @(
    'tools\Test-ArticlePublishReady.ps1',
    'tools\Test-PublishReadyPackage.ps1',
    'standards\13-新文章生成终稿闭环_v1.md'
)) {
    if (-not (Test-Path -LiteralPath (Join-Path $root $relative) -PathType Leaf)) {
        Add-Finding 'P0_WORKFLOW_COMPONENT_MISSING' $relative
    }
}

$soffice = Get-Command soffice -ErrorAction SilentlyContinue
if (-not $soffice) {
    $commonPath = 'C:\Program Files\LibreOffice\program\soffice.exe'
    if (Test-Path -LiteralPath $commonPath -PathType Leaf) {
        $soffice = Get-Item -LiteralPath $commonPath
    }
}

if (-not $soffice) {
    Add-Finding 'P0_RENDERER_UNAVAILABLE' 'LibreOffice/soffice is not available. Final content may be produced, but Publish Ready must be recorded as Content Complete — Render QA Blocked before any research or writing begins.'
}

if ($findings.Count -eq 0) {
    Write-Output 'PASS — Article Generation Preflight Ready'
    Write-Output ("Renderer: {0}" -f $soffice.Source)
    exit 0
}

Write-Output 'BLOCKED — Article Generation Preflight'
Write-Output 'Findings:'
$findings | ForEach-Object { Write-Output ("- {0}" -f $_) }
if ($RequirePublishReady) { exit 2 }
exit 0
