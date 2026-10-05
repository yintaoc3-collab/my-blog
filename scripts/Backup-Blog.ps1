param([string]$OutputPath)
$ErrorActionPreference = 'Stop'
$blogRoot = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
if (!$OutputPath) {
    $backupRoot = Join-Path $blogRoot '.backups'
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    $OutputPath = Join-Path $backupRoot ('blog-source-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '.zip')
}
$OutputPath = [IO.Path]::GetFullPath($OutputPath)
New-Item -ItemType Directory -Path (Split-Path -Parent $OutputPath) -Force | Out-Null
if (Test-Path -LiteralPath $OutputPath) { throw ('不能覆盖已有备份：' + $OutputPath) }
$excludedRoots = @('.git','.tools','.backups','.build','.cache','public','resources','.hugo_build.lock')
$files = @(
    foreach ($item in (Get-ChildItem -LiteralPath $blogRoot -Force)) {
        if ($item.Name -in $excludedRoots) { continue }
        if ($item.PSIsContainer) { Get-ChildItem -LiteralPath $item.FullName -File -Recurse -Force } else { $item }
    }
) | Where-Object { $_.Name -ne '.hugo_build.lock' -and $_.Extension -ne '.log' -and $_.FullName -ne $OutputPath }
if (!$files) { throw '没有找到需要备份的源码。' }
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$stream = [IO.File]::Open($OutputPath,[IO.FileMode]::CreateNew,[IO.FileAccess]::ReadWrite,[IO.FileShare]::None)
try {
    $zip = [IO.Compression.ZipArchive]::new($stream,[IO.Compression.ZipArchiveMode]::Create,$true)
    try {
        foreach ($file in $files) {
            $name = $file.FullName.Substring($blogRoot.Length + 1).Replace('\','/')
            [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip,$file.FullName,$name,[IO.Compression.CompressionLevel]::Optimal) | Out-Null
        }
    } finally { $zip.Dispose() }
} finally { $stream.Dispose() }
Write-Host ('源码备份完成：' + $OutputPath)
Write-Host ('文件数：' + $files.Count + '。请再复制一份到其他磁盘。')
Write-Host '此备份包含文章、图片、主题、教程和部署文件；不包含 Hugo 程序、Git 历史和生成网页。'
$OutputPath
