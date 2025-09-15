# SYS-320-02
# Functions and Event Logs Script 3 (Driver)
# Christopher Lavalette
# 9/15/2025

# Dot-source the functions file (loads both functions into this script session)
. ("$PSScriptRoot\FEL_functions.ps1")

# Change Days value as needed, "I dont think this needs to be a command with a parameter"
$Days = 7

Write-Host "Logon / Logoff Events (last $Days days)"
Get-LogonLogoffEvents -Days $Days | Format-Table Time, Id, Event, User 

Write-Host ""
Write-Host "Startup / Shutdown Events (last $Days days)"
Get-StartShutdownEvents -Days $Days | Format-Table Time, Id, Event, User 
