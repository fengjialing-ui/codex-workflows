# Compatibility wrapper: the portable Python validator is authoritative.
[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$PackagePath)
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) { $python = Get-Command python3 -ErrorAction SilentlyContinue }
if (-not $python) { Write-Output 'BLOCKED: Python 3.10+ is required'; exit 2 }
& $python.Source (Join-Path $PSScriptRoot 'validate_article_package.py') --package $PackagePath
exit $LASTEXITCODE
