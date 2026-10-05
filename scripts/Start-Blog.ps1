param(
    [ValidateRange(1024,65535)][int]$Port = 1321,
    [switch]$NoBrowser
)
$ErrorActionPreference = 'Stop'
$blogRoot = [IO.Path]::GetFullPath((Split-Path -Parent $PSScriptRoot))
. (Join-Path $PSScriptRoot 'Preview-Helpers.ps1')
$hugoExe = & (Join-Path $PSScriptRoot 'Ensure-Hugo.ps1')
foreach ($preview in @(Get-BlogPreviewProcess -BlogRoot $blogRoot)) {
    $url = "http://127.0.0.1:$($preview.Port)/"
    try { $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 3 } catch { continue }
    if ($response.StatusCode -eq 200) {
        Write-Host ('正式版预览已经运行，直接使用：' + $url)
        Write-Host '无需再启动一份。停止预览可双击 stop-blog.cmd。'
        if (!$NoBrowser) { Start-Process -FilePath $url }
        return
    }
}
$selectedPort = Get-AvailableBlogPort -PreferredPort $Port
$url = "http://127.0.0.1:$selectedPort/"
if ($selectedPort -ne $Port) { Write-Host ("端口 $Port 已占用，自动改用 $selectedPort。") }
Write-Host ('正在启动正式版：' + $url)
Write-Host '本地预览会显示草稿；正式构建和 GitHub 网站不会发布 draft: true 的文章。'
Write-Host '保持这个窗口打开。按 Ctrl+C 或双击 stop-blog.cmd 停止预览。'
$hugoArgs = @('server','--source',$blogRoot,'--bind','127.0.0.1','--port',"$selectedPort",'--baseURL',$url,'--buildDrafts','--disableFastRender')
if (!$NoBrowser) { $hugoArgs += '--openBrowser' }
Push-Location -LiteralPath $blogRoot
try {
    & $hugoExe @hugoArgs
    if ($LASTEXITCODE -ne 0) { throw '预览已经停止。若启动失败，请查看窗口中的报错。' }
} finally { Pop-Location }
