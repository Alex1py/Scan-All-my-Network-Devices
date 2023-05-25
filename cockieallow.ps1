# Load the Selenium WebDriver module
Import-Module Selenium

# Specify the path to the browser driver
$driverPath = "C:\Path\To\Driver\chromedriver.exe"

# Start a new Chrome browser session
$driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($driverPath)

# Navigate to the website
$driver.Navigate().GoToUrl("https://www.example.com")

# Wait for the "Allow Cookies" button to load
$wait = New-Object OpenQA.Selenium.Support.UI.WebDriverWait($driver, [System.TimeSpan]::FromSeconds(10))
$element = $wait.Until({$driver.FindElementById("allow-cookies")})

# Click the "Allow Cookies" button
$element.Click()

# Close the browser
$driver.Quit()
