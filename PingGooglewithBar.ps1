Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Ping Google.com"
$form.ClientSize = New-Object System.Drawing.Size(300, 115)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 30)
$progressBar.Size = New-Object System.Drawing.Size(280, 20)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$form.Controls.Add($progressBar)

$progressLabel = New-Object System.Windows.Forms.Label
$progressLabel.Location = New-Object System.Drawing.Point(130, 5)
$progressLabel.Size = New-Object System.Drawing.Size(50, 20)
$form.Controls.Add($progressLabel)

$pingButton = New-Object System.Windows.Forms.Button
$pingButton.Location = New-Object System.Drawing.Point(10, 60)
$pingButton.Size = New-Object System.Drawing.Size(120, 30)
$pingButton.Text = "Ping Google.com"
$pingButton.Add_Click({
    $result = Test-Connection -Count 5 -ComputerName "google.com"
    [System.Windows.Forms.MessageBox]::Show($result.Status)
})
$form.Controls.Add($pingButton)

$startButton = New-Object System.Windows.Forms.Button
$startButton.Location = New-Object System.Drawing.Point(200, 5)
$startButton.Size = New-Object System.Drawing.Size(90, 20)
$startButton.Text = "Start"
$startButton.Add_Click({
    $i = 0
    while ($i -le 100) {
        $progressBar.Value = $i
        $progressLabel.Text = "$i%"
        $i += 5
        Start-Sleep -Milliseconds 100
    }
})
$form.Controls.Add($startButton)

$form.ShowDialog() | Out-Null
