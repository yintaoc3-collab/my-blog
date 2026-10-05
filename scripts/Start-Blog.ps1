param([ValidateRange(1024,65535)][int]$Port = 1313)
$ErrorActionPreference = 'Stop'
$blogRoot = Split-Path -Parent $PSScriptRoot
$hugoExe = & (Join-Path $PSScriptRoot 'Ensure-Hugo.ps1')
Push-Location -LiteralPath $blogRoot
try {
    Write-Host "Open http://127.0.0.1:$Port/ in your browser."
    Write-Host 'Drafts are visible in this LOCAL preview. Press Ctrl+C to stop.'
    & $hugoExe server --bind 127.0.0.1 --port $Port --baseURL "http://127.0.0.1:$Port/" --buildDrafts --disableFastRender
    if ($LASTEXITCODE -ne 0) { throw 'Local preview stopped with an error. Read the error message above.' }
} finally {
    Pop-Location
}
