$computerName = "192.168.178.56"
$osInfo = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computerName
$hostname = (Test-NetConnection -ComputerName $computerName).ComputerName
$osName = $osInfo.Caption
$osVersion = $osInfo.Version
$osBitness = $osInfo.OSArchitecture

Write-Host "Hostname: $hostname"
Write-Host "OS Name: $osName"
Write-Host "OS Version: $osVersion"
Write-Host "OS Bitness: $osBitness"
