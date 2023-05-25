$chromePath = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)'
$url = "https://www.youtube.com/watch?v=Uv4LdDyV650&list=PLfHe8i5c4XMyFt_1nE7RpZ5SzDXPgSXID&ab_channel=ITPositiv"
Start-Process -FilePath $chromePath -ArgumentList $url