# Get the IP address range for the local network
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias (Get-NetAdapter).Name).IPAddress
$subnetMask = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias (Get-NetAdapter).Name).PrefixLength
$subnetMask = ([IPAddress]::Any).Address -shl (32 - $subnetMask)
$networkAddress = [IPAddress]::Parse($ipAddress.GetAddressBytes() | ForEach-Object { $_ -band $subnetMask.GetAddressBytes() } -join ".")
$broadcastAddress = [IPAddress]::Parse($ipAddress.GetAddressBytes() | ForEach-Object { $_ -bnot -bor $subnetMask.GetAddressBytes() } -join ".")

# Find all the computers on the local network
$pingResults = Invoke-Command -ComputerName ($networkAddress..$broadcastAddress).ToString() -ScriptBlock { param($ip) Test-Connection -ComputerName $ip -Count 1 -Quiet } -AsJob | Wait-Job | Receive-Job

# Filter the ping results to get the names and IP addresses of the computers that responded
$computers = $pingResults | Where-Object { $_ -ne $null } | ForEach-Object { [System.Net.Dns]::GetHostEntry($_).HostName + " (" + $_ + ")" }

# Get the operating system information for each computer
$operatingSystems = $computers | ForEach-Object {
    $ip = $_.Split("(")[1].TrimEnd(")")
    $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $ip
    $os.Caption + " " + $os.Version
}

# Display the results
for ($i = 0; $i -lt $computers.Count; $i++) {
    Write-Output "Computer Name: $($computers[$i])"
    Write-Output "IP Address: $($computers[$i].Split("(")[1].TrimEnd(")"))"
    Write-Output "Operating System: $($operatingSystems[$i])`n"
}
