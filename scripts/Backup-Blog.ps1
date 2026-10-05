$ErrorActionPreference = 'Stop'
$blogRoot = Split-Path -Parent $PSScriptRoot
$backupRoot = Join-Path $blogRoot '.backups'
New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
$backupFile = Join-Path $backupRoot ('blog-source-' + (Get-Date -Format 'yyyyMMdd-HHmmss') + '.zip')
$sourcePaths = Get-ChildItem -LiteralPath $blogRoot -Force | Where-Object { $_.Name -notin @('.git','.tools','.backups','.build','.cache','public','resources','.hugo_build.lock') } | Select-Object -ExpandProperty FullName
if (-not $sourcePaths) { throw 'No source files found to back up.' }
# -Force above includes .github and .gitignore in the source selection.
Compress-Archive -LiteralPath $sourcePaths -DestinationPath $backupFile -CompressionLevel Optimal
Write-Host "Backup saved to: $backupFile"
Write-Host 'Copy this ZIP to another disk. It contains source files, not Git history or local Hugo binaries.'
