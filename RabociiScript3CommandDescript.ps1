# Create an array of commands with their descriptions
$commands = @(
    @{Name='ping'; Description='Sends an ICMP echo request to a network device to check if it is reachable.'},
    @{Name='ipconfig'; Description='Displays network configuration information for all network adapters in the system.'},
    @{Name='netstat'; Description='Displays active TCP connections, ports on which the computer is listening, Ethernet statistics, the IP routing table, IPv4 statistics (for the IP, ICMP, TCP, and UDP protocols), and IPv6 statistics (for the IPv6, ICMPv6, TCP over IPv6, and UDP over IPv6 protocols).'}
)

# Create a function to display the description of the command
function ShowCommandDescription($command) {
    $description = ($commands | Where-Object {$_.Name -eq $command}).Description
    $outputBox.Text = $description
}

# Create the GUI
Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Command Descriptions"
$form.Width = 400
$form.Height = 200
$form.StartPosition = "CenterScreen"

$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(10, 10)
$button1.Size = New-Object System.Drawing.Size(150, 30)
$button1.Text = "Ping"
$button1.Add_Click({ShowCommandDescription("ping")})
$form.Controls.Add($button1)

$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(170, 10)
$button2.Size = New-Object System.Drawing.Size(150, 30)
$button2.Text = "IPConfig"
$button2.Add_Click({ShowCommandDescription("ipconfig")})
$form.Controls.Add($button2)

$button3 = New-Object System.Windows.Forms.Button
$button3.Location = New-Object System.Drawing.Point(10, 50)
$button3.Size = New-Object System.Drawing.Size(150, 30)
$button3.Text = "NetStat"
$button3.Add_Click({ShowCommandDescription("netstat")})
$form.Controls.Add($button3)

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(10, 90)
$outputBox.Size = New-Object System.Drawing.Size(380, 100)
$outputBox.Multiline = $true
$outputBox.ReadOnly = $true
$form.Controls.Add($outputBox)

$form.ShowDialog() | Out-Null
