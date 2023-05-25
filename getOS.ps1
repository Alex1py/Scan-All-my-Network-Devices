$ipAddress = "192.168.178.61"
$os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ipAddress
$os.Caption
