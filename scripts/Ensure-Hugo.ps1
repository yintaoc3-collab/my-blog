$ErrorActionPreference = 'Stop'
$blogRoot = Split-Path -Parent $PSScriptRoot
$toolRoot = Join-Path $blogRoot '.tools\hugo'
$hugoExe = Join-Path $toolRoot 'hugo.exe'
$hugoVersion = '0.167.0'
$expectedChecksum = 'f5ed1983b4373e719434cd721bf931907dec8ad33a891a6912903e93cfdcce98'

if (Test-Path -LiteralPath $hugoExe) {
    $versionOutput = (& $hugoExe version | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or $versionOutput -notmatch 'hugo v0\.167\.0(?:-|\s)') {
        throw 'The bundled Hugo version is incorrect. Restore .tools/hugo from your original package.'
    }
    return $hugoExe
}

New-Item -ItemType Directory -Path $toolRoot -Force | Out-Null
$archive = Join-Path $toolRoot "hugo_${hugoVersion}_windows-amd64.zip"
$downloadURL = "https://github.com/gohugoio/hugo/releases/download/v${hugoVersion}/hugo_${hugoVersion}_windows-amd64.zip"
Write-Host "Downloading the pinned Hugo version $hugoVersion from GitHub..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -UseBasicParsing -Uri $downloadURL -OutFile $archive
$actualChecksum = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
if ($actualChecksum -ne $expectedChecksum) {
    throw 'Download checksum mismatch. Do not run this downloaded file; download a verified package again.'
}
Expand-Archive -LiteralPath $archive -DestinationPath $toolRoot -Force
if (-not (Test-Path -LiteralPath $hugoExe)) { throw 'hugo.exe was not found in the downloaded archive.' }
return $hugoExe
