Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Ping Status"
$Form.Size = New-Object System.Drawing.Size(300,150)
$Form.StartPosition = "CenterScreen"

$Progress = New-Object System.Windows.Forms.ProgressBar
$Progress.Location = New-Object System.Drawing.Point(10,50)
$Progress.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($Progress)

$PercentLabel = New-Object System.Windows.Forms.Label
$PercentLabel.Location = New-Object System.Drawing.Point(130, 75)
$PercentLabel.Size = New-Object System.Drawing.Size(40,20)
$PercentLabel.TextAlign = "MiddleCenter"
$Form.Controls.Add($PercentLabel)

$PingButton = New-Object System.Windows.Forms.Button
$PingButton.Location = New-Object System.Drawing.Point(100,100)
$PingButton.Size = New-Object System.Drawing.Size(100,30)
$PingButton.Text = "Ping"
$Form.Controls.Add($PingButton)

$PingButton.Add_Click({
    $Progress.Value = 0
    $Ping = New-Object System.Net.NetworkInformation.Ping
    $PercentLabel.Text = "0%"

    $Result = $Ping.Send("google.com")
    $i = 0

    while($i -lt 10) {
        $Progress.PerformStep()
        $i++
        $PercentLabel.Text = $Progress.Value.ToString() + "%"
        Start-Sleep -Milliseconds 500
    }

    if($Result.Status -eq "Success") {
        [System.Windows.Forms.MessageBox]::Show("Ping successful!")
    }
})

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
