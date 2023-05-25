# Get the local IP address and subnet mask
$ipAddress = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like '*Wi-Fi*' }).IPAddress
$subnetMask = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like '*Wi-Fi*' }).PrefixLength
$subnetMask = [IPAddress]::new(([Math]::Pow(2, $subnetMask) - 1) * [Math]::Pow(2, (32 - $subnetMask)), 0)

# Calculate the network address
$networkAddress = [IPAddress]::new((([IPAddress]$ipAddress).GetAddressBytes() -band $subnetMask.GetAddressBytes()), 0)

# Get a list of IP addresses in the range
$ipRange = $networkAddress..([IPAddress]::Broadcast) | ForEach-Object { $_.ToString() }

# Ping each IP address in the range and get the corresponding MAC address
$arpTable = @{}
foreach ($ip in $ipRange) {
    $pingResult = (Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue)
    if ($pingResult) {
        $macAddress = (Get-NetNeighbor -IPAddress $ip -AddressFamily IPv4 -ErrorAction SilentlyContinue).LinkLayerAddress
        if ($macAddress -ne $null) {
            $arpTable.Add($ip, $macAddress)
        }
    }
}

# Output the results
$arpTable.GetEnumerator() | ForEach-Object {
    $hostName = (Resolve-DnsName $_.Name -ErrorAction SilentlyContinue).NameHost
    $ipAddress = $_.Name
    $macAddress = $_.Value
    Write-Output "$ipAddress [$macAddress] ($hostName)"
}
