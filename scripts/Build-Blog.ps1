$ErrorActionPreference = 'Stop'
$blogRoot = Split-Path -Parent $PSScriptRoot
$hugoExe = & (Join-Path $PSScriptRoot 'Ensure-Hugo.ps1')
Push-Location -LiteralPath $blogRoot
try {
    # public/ is a dedicated Hugo output directory. Remove stale generated pages here only.
    & $hugoExe --gc --minify --cleanDestinationDir --destination (Join-Path $blogRoot 'public')
    if ($LASTEXITCODE -ne 0) { throw 'Build failed. Read the error message above.' }
    Write-Host 'Build succeeded. Generated pages are in public/. Draft articles are excluded.'
} finally {
    Pop-Location
}
