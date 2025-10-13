# SYS-320, Christopher Lavalette
# Configuration.ps1

# Path to configuration file
$configFile = "configuration.txt"

# Function: readConfiguration
function readConfiguration {
    if (-not (Test-Path $configFile)) {
        Write-Host "Configuration file not found. Creating a new one..."
        "30" | Out-File $configFile
        "1:00 PM" | Out-File $configFile -Append
    }

    $config = Get-Content $configFile
    [PSCustomObject]@{
        Days           = $config[0]
        ExecutionTime  = $config[1]
    }
}

# Function: changeConfiguration
function changeConfiguration {
    do {
        $days = Read-Host "Enter the number of days for which the logs will be obtained"
    } until ($days -match '^\d+$')  # Only digits allowed

    do {
        $time = Read-Host "Enter the daily execution time of the script (Format: H:MM AM/PM)"
    } until ($time -match '^(1[0-2]|0?[1-9]):[0-5][0-9]\s?(AM|PM)$')  # e.g. 1:22 PM

    # Overwrite the configuration file
    Set-Content -Path $configFile -Value $days
    Add-Content -Path $configFile -Value $time

    Write-Host "Configuration Changed`n"
}


# Function: configurationMenu
function configurationMenu {
    do {
        Write-Host "Please choose your operation:"
        Write-Host "1 - Show Configuration"
        Write-Host "2 - Change Configuration"
        Write-Host "3 - Exit"
        $choice = Read-Host

        switch ($choice) {
            1 {
                $config = readConfiguration
                Write-Host ""
                $config | Format-Table -AutoSize
                Write-Host ""
            }
            2 {
                changeConfiguration
            }
            3 {
                Write-Host "Exiting..."
            }
            default {
                Write-Host "Invalid choice. Please enter 1, 2, or 3.`n"
            }
        }
    } until ($choice -eq 3)
}

# Start the menu
configurationMenu
