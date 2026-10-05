$ErrorActionPreference = 'Stop'
$blogRoot = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
. (Join-Path $PSScriptRoot 'Preview-Helpers.ps1')
$previews = @(Get-BlogPreviewProcess -BlogRoot $blogRoot)
if (!$previews) { Write-Host '这份正式版博客没有正在运行的预览。'; return }
foreach ($preview in $previews) {
    $stillOwned = @(Get-BlogPreviewProcess -BlogRoot $blogRoot | Where-Object { $_.Id -eq $preview.Id })
    if (!$stillOwned) { continue }
    Stop-Process -Id $preview.Id -ErrorAction Stop
    Write-Host ("已停止正式版预览：http://127.0.0.1:$($preview.Port)/")
}
