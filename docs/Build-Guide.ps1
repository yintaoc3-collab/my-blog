# 渲染教程 HTML：docs\从零搭建个人博客-完整指南.md  ->  docs\从零搭建个人博客-完整指南.html
# 正文来源固定为 docs 下的 Markdown；脚本按自身位置定位博客根目录，可指定输出路径。
param([string]$OutputPath)
$ErrorActionPreference = 'Stop'

$docsRoot = $PSScriptRoot
$blogRoot = Split-Path -Parent $docsRoot
$guideSource = Join-Path $docsRoot 'guide-source'
$markdown = Join-Path $docsRoot '从零搭建个人博客-完整指南.md'
if (-not $OutputPath) { $OutputPath = Join-Path $docsRoot '从零搭建个人博客-完整指南.html' }

if (-not (Test-Path -LiteralPath (Join-Path $blogRoot 'hugo.yaml'))) {
    throw ('教程源码目录应位于博客仓库内（当前脚本位于 ' + $docsRoot + '）。请把 docs 文件夹放回博客根目录下。')
}

if (-not (Test-Path -LiteralPath $markdown)) { throw ('找不到教程正文: ' + $markdown) }
if (-not (Test-Path -LiteralPath $guideSource)) { throw ('找不到教程模板与配置: ' + $guideSource) }

$hugoExe = Join-Path $blogRoot '.tools\hugo\hugo.exe'
if (-not (Test-Path -LiteralPath $hugoExe)) {
    $found = Get-Command hugo -ErrorAction SilentlyContinue
    if (-not $found) { throw ('找不到 Hugo: ' + $hugoExe + ' 且 PATH 中也没有 hugo') }
    $hugoExe = $found.Source
}

# 确保模板目录中的 content 存在（首次使用或换机器解压后可能不存在）
$contentDir = Join-Path $guideSource 'content'
if (-not (Test-Path -LiteralPath $contentDir)) { New-Item -ItemType Directory -Path $contentDir -Force | Out-Null }

Copy-Item -LiteralPath $markdown -Destination (Join-Path $contentDir '_index.md') -Force

$renderRoot = Join-Path $blogRoot '.build\guide-render'
& $hugoExe --source $guideSource --destination $renderRoot --cleanDestinationDir --quiet
if ($LASTEXITCODE -ne 0) { throw '教程 HTML 渲染失败，请查看上面的错误信息。' }

$rendered = Join-Path $renderRoot 'index.html'
if (-not (Test-Path -LiteralPath $rendered)) { throw ('渲染结果不存在: ' + $rendered) }

Copy-Item -LiteralPath $rendered -Destination $OutputPath -Force
Write-Host ('教程已渲染: ' + $OutputPath)
Write-Host ('大小: ' + (Get-Item -LiteralPath $OutputPath).Length + ' 字节')
Write-Host ('正文来源: ' + $markdown)
