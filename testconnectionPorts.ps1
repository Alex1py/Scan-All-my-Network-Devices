$resource = Read-Host "Enter the network resource to test (e.g. server name or IP address):"

$ping = Test-NetConnection $resource -CommonTCPPort ICMP

if ($ping.PingSucceeded) {
    Write-Host "Ping test succeeded."
} else {
    Write-Host "Ping test failed."
}

$port = Read-Host "Enter the port number to test (e.g. 80 for HTTP):"

$portTest = Test-NetConnection $resource -Port $port

if ($portTest.TcpTestSucceeded) {
    Write-Host "Port test succeeded."
} else {
    Write-Host "Port test failed."
}
