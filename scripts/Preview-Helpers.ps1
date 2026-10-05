function Get-BlogPreviewProcess {
    param([Parameter(Mandatory)][string]$BlogRoot)
    $expectedExe = [IO.Path]::GetFullPath((Join-Path $BlogRoot '.tools\hugo\hugo.exe'))
    $sourcePattern = '(?<!\S)--source\s+(?:"' + [regex]::Escape($BlogRoot) + '"|' + [regex]::Escape($BlogRoot) + ')(?:\s|$)'
    foreach ($process in (Get-CimInstance Win32_Process -Filter "Name='hugo.exe'" -ErrorAction SilentlyContinue)) {
        if ($process.ExecutablePath -ne $expectedExe -or !$process.CommandLine -or $process.CommandLine -notmatch $sourcePattern) { continue }
        if ($process.CommandLine -notmatch '(?<!\S)server(?:\s|$)' -or $process.CommandLine -notmatch '--port(?:\s+|=)(\d+)') { continue }
        [pscustomobject]@{ Id = [int]$process.ProcessId; Port = [int]$Matches[1]; ExecutablePath = $expectedExe }
    }
}

function Get-AvailableBlogPort {
    param([ValidateRange(1024,65535)][int]$PreferredPort = 1321)
    for ($candidate = $PreferredPort; $candidate -le [Math]::Min(65535, $PreferredPort + 20); $candidate++) {
        $listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, $candidate)
        try { $listener.Start(); return $candidate } catch [Net.Sockets.SocketException] { } finally { $listener.Stop() }
    }
    throw ('没有找到空闲预览端口，请先关闭不用的预览，或用 -Port 指定其他端口。')
}
