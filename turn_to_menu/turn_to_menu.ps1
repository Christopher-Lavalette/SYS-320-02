# Christopher Lavalette, SYS 320
# Turn To Table Menu Script

. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)
. (Join-Path $PSScriptRoot Apache-Logs.ps1)
. (Join-Path $PSScriptRoot chromestart_stop.ps1)

Clear-Host

$Prompt = @"
Please choose your operation:
1 - Display Last 10 Apache Logs
2 - Display Last 10 Failed Logins for All Users
3 - Display At Risk Users
4 - Start Chrome and Go to champlain.edu
5 - Exit
"@

$loop = $true

while ($loop) {

    Write-Host $Prompt
    $choice = Read-Host "Enter your choice (1-5)"

    switch ($choice) {

        1 {
            Write-Host "`n--- Last 10 Apache Logs ---"
            try {
                $logs = Get-ApacheLogs ".*" ".*" ".*" | Select-Object -Last 10
                if ($logs) {
                    $logs | Format-Table -AutoSize
                } else {
                    Write-Host "No Apache logs found matching the criteria."
                }
            } catch {
                Write-Host "Error reading Apache logs: $($_.Exception.Message)"
            }
        }

        2 {
            Write-Host "`n--- Last 10 Failed Logins ---"
            try {
                $failed = getFailedLogins 30 | Select-Object -Last 10
                if ($failed) {
                    $failed | Format-Table -AutoSize
                } else {
                    Write-Host "No failed login attempts found."
                }
            } catch {
                Write-Host "Error retrieving failed login data: $($_.Exception.Message)"
            }
        }

        3 {
            Write-Host "`n--- At Risk Users ---"
            try {
                $days = Read-Host -Prompt "Enter how many days back to check"
                $failed = getFailedLogins $days
                $grouped = $failed | Group-Object User | Where-Object { $_.Count -gt 10 }

                if ($grouped.Count -eq 0) {
                    Write-Host "No users with more than 10 failed logins."
                } else {
                    $grouped | ForEach-Object {
                        [pscustomobject]@{
                            User  = $_.Name
                            Count = $_.Count
                        }
                    } | Format-Table -AutoSize
                }
            } catch {
                Write-Host "Error checking at-risk users: $($_.Exception.Message)"
            }
        }

        4 {
            startChrome
        }

        5 {
            Write-Host "Exiting program..."
            $loop = $false
        }

        Default {
            Write-Host "Invalid input. Please enter a number between 1 and 5."
        }
    }

    if ($loop) {
        Write-Host "`nPress Enter to continue..."
        Read-Host
        Clear-Host
    }
}
#Comment for extra good luck with the script properly working!