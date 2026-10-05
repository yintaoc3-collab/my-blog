# Render 开始使用.md with the bundled guide template.
param([string]$OutputPath)
$ErrorActionPreference = 'Stop'
$docsRoot = $PSScriptRoot
$blogRoot = Split-Path -Parent $docsRoot
$markdown = Join-Path $docsRoot '开始使用.md'
$hugoExe = Join-Path $blogRoot '.tools\hugo\hugo.exe'
$template = Join-Path $docsRoot 'guide-source'
foreach ($required in @($markdown, $hugoExe, (Join-Path $template 'hugo.yaml'), (Join-Path $template 'layouts\home.html'))) {
    if (-not (Test-Path -LiteralPath $required)) { throw ('Missing file: ' + $required) }
}
if (-not $OutputPath) { $OutputPath = Join-Path $docsRoot '开始使用.html' }
$renderRoot = [IO.Path]::GetFullPath((Join-Path $blogRoot '.build\start-guide'))
$blogPrefix = [IO.Path]::GetFullPath($blogRoot).TrimEnd('\') + '\'
if (-not $renderRoot.StartsWith($blogPrefix, [StringComparison]::OrdinalIgnoreCase)) { throw 'Invalid render path.' }
$source = Join-Path $renderRoot 'source'
$output = Join-Path $renderRoot 'public'
New-Item -ItemType Directory -Path (Join-Path $source 'content'), (Join-Path $source 'layouts') -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $template 'hugo.yaml') -Destination (Join-Path $source 'hugo.yaml') -Force
Copy-Item -LiteralPath (Join-Path $template 'layouts\home.html') -Destination (Join-Path $source 'layouts\home.html') -Force
Copy-Item -LiteralPath $markdown -Destination (Join-Path $source 'content\_index.md') -Force
& $hugoExe --source $source --destination $output --cleanDestinationDir --quiet
if ($LASTEXITCODE -ne 0) { throw 'Local usage guide rendering failed.' }
Copy-Item -LiteralPath (Join-Path $output 'index.html') -Destination $OutputPath -Force
Write-Host ('Local usage guide rendered: ' + $OutputPath)
