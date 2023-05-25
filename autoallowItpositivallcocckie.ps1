# Specify the URL to open
$url = "https://www.youtube.com/watch?v=Uv4LdDyV650&list=PLfHe8i5c4XMyFt_1nE7RpZ5SzDXPgSXID&ab_channel=ITPositiv"

# Create a new Internet Explorer object
$ie = New-Object -ComObject Google Chrome.Application

# Make IE visible
$ie.Visible = $true

# Navigate to the URL
$ie.Navigate($url)

# Wait for the page to load
while ($ie.Busy -eq $true) {
    Start-Sleep -Milliseconds 100
}

# Accept all cookies
$ie.Document.cookie = ""

# Close IE
$ie.Quit()
