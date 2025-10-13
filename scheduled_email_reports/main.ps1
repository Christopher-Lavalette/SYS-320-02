#SYS-320, Christopher Lavalette
# main.ps1

# Import required scripts
. .\Email.ps1
. .\Scheduler.ps1
. .\Configuration.ps1
. .\Event-Logs.ps1

Write-Host "Starting main script..." 

# 1. Obtain configuration
Write-Host "`n# Obtaining configuration"
$configuration = readConfiguration
Write-Host "Configuration loaded:`n"
$configuration | Format-Table -AutoSize

# 2. Obtain at-risk users
Write-Host "`n# Obtaining at-risk users"
$Failed = getFailedLogins $configuration.Days

# 3. Send at-risk users as email
Write-Host "`n# Sending at-risk users as email"
# Convert to table string for readability in email
$Body = ""
if ($Failed -and $Failed.Count -gt 0) {
    $Body = $Failed | Format-Table -AutoSize | Out-String
} else {
    $Body = "No suspicious activity found!"
}

# Send the email using your SendAlertEmail function
SendAlertEmail $Body

# 4. Set the script to be run daily
Write-Host "`n# Setting the script to be run daily"
$time = $configuration.ExecutionTime
ChooseTimeToRun $time

Write-Host "`nMain script completed successfully." 
