# Import the required .NET namespaces
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a form object
$form = New-Object System.Windows.Forms.Form
$form.Text = "Local Network Computers Information"
$form.ClientSize = New-Object System.Drawing.Size(400,300)
$form.StartPosition = "CenterScreen"

# Create a label object
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(380,20)
$label.Text = "Click the button to retrieve local network computers information."
$form.Controls.Add($label)

# Create a button object
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150,50)
$button.Size = New-Object System.Drawing.Size(100,23)
$button.Text = "Retrieve Info"
$button.Add_Click({
    # Retrieve the local network computers information
    $ipRange = Get-NetIPConfiguration | Where-Object { $_.IPv4Address } | Select-Object -ExpandProperty IPv4Address
    $pingResults = Test-Connection -ComputerName $ipRange -Count 1 -ErrorAction SilentlyContinue
    $pingedComputers = $pingResults | Where-Object { $_.StatusCode -eq 0 } | Select-Object -ExpandProperty Address
    $computerInfo = foreach ($computer in $pingedComputers) {
        $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
        [PSCustomObject]@{
            "Hostname" = (Resolve-DnsName -Name $computer -ErrorAction SilentlyContinue).NameHost
            "IP Address" = $computer
            "MAC Address" = Get-NetNeighbor -IPAddress $computer -AddressFamily IPv4 | Select-Object -ExpandProperty LinkLayerAddress
            "OS" = $os.Caption
        }
    }

    # Create a new form to display the information
    $resultsForm = New-Object System.Windows.Forms.Form
    $resultsForm.Text = "Local Network Computers Information"
    $resultsForm.ClientSize = New-Object System.Drawing.Size(700,400)
    $resultsForm.StartPosition = "CenterScreen"

    # Create a list view object to display the information
    $listView = New-Object System.Windows.Forms.ListView
    $listView.Location = New-Object System.Drawing.Point(10,10)
    $listView.Size = New-Object System.Drawing.Size(670,350)
    $listView.Columns.Add("Hostname", 150) | Out-Null
    $listView.Columns.Add("IP Address", 120) | Out-Null
    $listView.Columns.Add("MAC Address", 120) | Out-Null
    $listView.Columns.Add("Operating System", 280) | Out-Null
    $resultsForm.Controls.Add($listView)

    # Add each computer's information to the list view
    foreach ($computer in $computerInfo) {
        $listItem = New-Object System.Windows.Forms.ListViewItem($computer.Hostname)
        $listItem.SubItems.Add($computer.'IP Address')
        $listItem.SubItems.Add($computer.'MAC Address')
        $listItem.SubItems.Add($computer.OS)
        [void]$listView.Items.Add($listItem)
    }

    # Show the form
    $resultsForm.ShowDialog() | Out-Null
})
$form.Controls.Add($button)

# Show the
