param (
    [string]$Page,
    [string]$HttpCode,
    [string]$Browser
)

# Load the function from Apache-Logs.ps1
. "$PSScriptRoot\Apache-Logs.ps1"

# Call the function with user-supplied inputs
Get-ApacheLogs -Page $Page -HttpCode $HttpCode -Browser $Browser
