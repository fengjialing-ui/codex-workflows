# Capability failure always returns non-zero; legacy switch is accepted for compatibility.
[CmdletBinding()]
param([switch]$RequirePublishReady, [string]$Renderer)
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) { $python = Get-Command python3 -ErrorAction SilentlyContinue }
if (-not $python) { Write-Output 'BLOCKED: Python 3.10+ is required'; exit 2 }
$arguments = @((Join-Path $PSScriptRoot 'preflight.py'))
if ($Renderer) { $arguments += @('--renderer', $Renderer) }
& $python.Source @arguments
exit $LASTEXITCODE
