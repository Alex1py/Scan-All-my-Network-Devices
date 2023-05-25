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

# Create an array of output strings
$output = for ($i = 0; $i -lt $computers.Count; $i++) {
    $computerOutput = "Computer Name: $($computers[$i])"
    $computerOutput += "`nIP Address: $($computers[$i].Split("(")[1].TrimEnd(")"))"
    $computerOutput += "`nOperating System: $($operatingSystems[$i])`n"
    $computerOutput
}

# Display the output in a separate window
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Multiline = $true
$textBox.ScrollBars = "Vertical"
$textBox.Width = 800
$textBox.Height = 600
$textBox.Text = $output -join "`n`n"
$form = New-Object System.Windows.Forms.Form
$form.Text = "Network Computers"
$form.Width = $textBox.Width
$form.Height = $textBox.Height
$form.Controls.Add($textBox)
$form.ShowDialog() | Out-Null
