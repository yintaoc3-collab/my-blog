# 打包新版交付基础包：博客源码（含便携 Hugo）+ docs 教程与脚本。
# 用法：powershell -ExecutionPolicy Bypass -File Package-Blog.ps1 [-OutputPath <zip>] [-BlogFolderName <包内文件夹名>]
# 包内一律使用中性文件夹名（默认 my-blog），与教程及 README 写法一致。
# 来源固定为博客根目录（脚本所在 docs 的上一级）；不含 .git、public、resources、.build、.backups。
# 本文件必须保存为 UTF-8 带 BOM，否则 Windows PowerShell 5.1 会读乱中文。
param(
    [string]$OutputPath,
    [string]$BlogFolderName = 'my-blog'
)
$ErrorActionPreference = 'Stop'

$docsRoot = $PSScriptRoot
$blogRoot = Split-Path -Parent $docsRoot
if (-not (Test-Path -LiteralPath (Join-Path $blogRoot 'hugo.yaml'))) {
    throw ('请把 docs 文件夹放回博客根目录下；当前脚本位于 ' + $docsRoot)
}
if (-not (Test-Path -LiteralPath (Join-Path $blogRoot '.tools\hugo\hugo.exe'))) {
    throw '基础包必须包含便携 Hugo：缺少 .tools\hugo\hugo.exe（可先运行 start-blog.cmd 下载）'
}
if ($BlogFolderName -notmatch '^[A-Za-z0-9._-]+$') { throw ('包内文件夹名只能用英文、数字、点、下划线、连字符: ' + $BlogFolderName) }
if (-not $OutputPath) {
    $stamp = Get-Date -Format 'yyyyMMdd'
    $OutputPath = Join-Path (Split-Path -Parent $blogRoot) ('个人博客完整教程与基础包-已配置-' + $stamp + '.zip')
}
$OutputPath = [IO.Path]::GetFullPath($OutputPath)
New-Item -ItemType Directory -Path (Split-Path -Parent $OutputPath) -Force | Out-Null
if (Test-Path -LiteralPath $OutputPath) { throw ('同名基础包已存在，不能覆盖: ' + $OutputPath) }

$stageRoot = [IO.Path]::GetFullPath((Join-Path $blogRoot '.build\staging'))
$expectedStage = [IO.Path]::GetFullPath((Join-Path $blogRoot '.build\staging'))
$resolvedBlogPrefix = [IO.Path]::GetFullPath($blogRoot).TrimEnd('\') + '\'
if ($stageRoot -ne $expectedStage -or -not $stageRoot.StartsWith($resolvedBlogPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Staging directory is outside the intended blog root.'
}
if (Test-Path -LiteralPath $stageRoot) { throw ('临时目录已存在，请先清理: ' + $stageRoot) }
New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null

try {
    $stageBlog = Join-Path $stageRoot $BlogFolderName
    New-Item -ItemType Directory -Path $stageBlog -Force | Out-Null
    foreach ($item in (Get-ChildItem -LiteralPath $blogRoot -Force)) {
        if ($item.Name -in @('.git', '.backups', '.build', '.cache', 'public', 'resources', '.hugo_build.lock')) { continue }
        if ($item.Name -eq 'docs') { continue }
        if ($item.PSIsContainer) {
            Copy-Item -LiteralPath $item.FullName -Destination (Join-Path $stageBlog $item.Name) -Recurse -Force
        } else {
            Copy-Item -LiteralPath $item.FullName -Destination (Join-Path $stageBlog $item.Name) -Force
        }
    }
    Copy-Item -LiteralPath $docsRoot -Destination (Join-Path $stageBlog 'docs') -Recurse -Force
    if (Test-Path -LiteralPath (Join-Path $stageBlog 'docs\.build')) { Remove-Item -LiteralPath (Join-Path $stageBlog 'docs\.build') -Recurse -Force }

    $staged = Get-ChildItem -LiteralPath $stageRoot -Recurse -Force -File
    Write-Host ('打包来源: ' + $blogRoot)
    Write-Host ('包内文件夹名: ' + $BlogFolderName + '   暂存文件数: ' + $staged.Count)

    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    # CreateNew：即使检查之后出现同名文件也会报错，绝不覆盖
    $stream = [IO.File]::Open($OutputPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
    $zip = New-Object IO.Compression.ZipArchive($stream, [IO.Compression.ZipArchiveMode]::Create, $false)
    try {
        foreach ($file in $staged) {
            $name = $file.FullName.Substring($stageRoot.Length + 1).Replace('\', '/')
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.FullName, $name, [IO.Compression.CompressionLevel]::Optimal) | Out-Null
        }
    } finally {
        $zip.Dispose()
        $stream.Dispose()
    }

    $required = @(
        ($BlogFolderName + '/hugo.yaml'),
        ($BlogFolderName + '/.github/workflows/hugo.yaml'),
        ($BlogFolderName + '/.gitignore'),
        ($BlogFolderName + '/.gitattributes'),
        ($BlogFolderName + '/.tools/hugo/hugo.exe'),
        ($BlogFolderName + '/.tools/hugo/LICENSE'),
        ($BlogFolderName + '/themes/PaperMod/LICENSE'),
        ($BlogFolderName + '/scripts/Ensure-Hugo.ps1'),
        ($BlogFolderName + '/docs/从零搭建个人博客-完整指南.md'),
        ($BlogFolderName + '/docs/从零搭建个人博客-完整指南.html'),
        ($BlogFolderName + '/docs/Build-Guide.ps1'),
        ($BlogFolderName + '/docs/Package-Blog.ps1'),
        ($BlogFolderName + '/docs/guide-source/hugo.yaml'),
        ($BlogFolderName + '/docs/guide-source/layouts/home.html'),
        ($BlogFolderName + '/layouts/home.html'),
        ($BlogFolderName + '/layouts/single.html'),
        ($BlogFolderName + '/layouts/_partials/lab-card.html'),
        ($BlogFolderName + '/assets/css/extended/zz-workbench.css'),
        ($BlogFolderName + '/static/images/workbench.svg'),
        ($BlogFolderName + '/assets/images/anime-workbench.png'),
        ($BlogFolderName + '/assets/images/anime-mascot.png'),
        ($BlogFolderName + '/docs/二次元配图与参考来源.md'),
        ($BlogFolderName + '/start-ui-preview.cmd'),
        ($BlogFolderName + '/docs/UI新版方案与使用指南.md'),
        ($BlogFolderName + '/docs/UI新版方案与使用指南.html'),
        ($BlogFolderName + '/docs/Build-UI-Guide.ps1')
    )
    $reader = [IO.Compression.ZipFile]::OpenRead($OutputPath)
    try {
        $names = @{}
        foreach ($entry in $reader.Entries) { $names[$entry.FullName] = $true }
        $missing = @()
        foreach ($item in $required) { if (-not $names.ContainsKey($item)) { $missing += $item } }
        if ($missing.Count -gt 0) {
            Write-Host '缺少以下内容:'
            foreach ($item in $missing) { Write-Host ('    - ' + $item) }
            throw ('基础包校验失败，缺少 ' + $missing.Count + ' 项')
        }
        $cfgEntry = $reader.GetEntry($BlogFolderName + '/hugo.yaml')
        $sr = New-Object IO.StreamReader($cfgEntry.Open())
        $cfgText = $sr.ReadToEnd(); $sr.Dispose()
        if ($cfgText -notmatch 'yintaoc3-collab') { throw '包内 hugo.yaml 不是新版配置（未包含用户名）' }
        if ($cfgText -match 'YOUR_GITHUB_USERNAME') { throw '包内 hugo.yaml 仍含旧占位符' }
        if ($names.ContainsKey($BlogFolderName + '/content/projects/example-project/index.md')) { throw '包内仍含已删除的示例文章' }
        Write-Host ('基础包已生成: ' + $OutputPath)
        Write-Host ('条目数: ' + $reader.Entries.Count)
        Write-Host ('大小: ' + [math]::Round((Get-Item -LiteralPath $OutputPath).Length / 1MB, 2) + ' MiB')
        Write-Host ('SHA-256: ' + (Get-FileHash -LiteralPath $OutputPath -Algorithm SHA256).Hash.ToLowerInvariant())
    } finally { $reader.Dispose() }
} finally {
    if (Test-Path -LiteralPath $stageRoot) { Remove-Item -LiteralPath $stageRoot -Recurse -Force }
}
