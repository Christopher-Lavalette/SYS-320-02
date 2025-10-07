# Christopher Lavalette, SYS 320
# Main Menu for Local User Management

. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List At Risk Users`n"
$Prompt += "10 - Exit`n"

$operation = $true

while($operation){

    Write-Host $Prompt | Out-String
    $choice = Read-Host 

    if($choice -eq 10){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 3){ 
        $name = Read-Host -Prompt "Please enter the username for the new user"
        $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

        if(checkUser $name){
            Write-Host "User already exists. Please choose another username." | Out-String
            continue
        }

        if(-not (checkPassword $password)){
            Write-Host "Password must be at least 6 characters and include a letter, number, and special character." | Out-String
            continue
        }

        createAUser $name $password
        Write-Host "User: $name is created." | Out-String
    }

    elseif($choice -eq 4){
        $name = Read-Host -Prompt "Please enter the username for the user to be removed"
        if(-not (checkUser $name)){
            Write-Host "User does not exist." | Out-String
            continue
        }
        removeAUser $name
        Write-Host "User: $name Removed." | Out-String
    }

    elseif($choice -eq 5){
        $name = Read-Host -Prompt "Please enter the username for the user to be enabled"
        if(-not (checkUser $name)){
            Write-Host "User does not exist." | Out-String
            continue
        }
        enableAUser $name
        Write-Host "User: $name Enabled." | Out-String
    }

    elseif($choice -eq 6){
        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"
        if(-not (checkUser $name)){
            Write-Host "User does not exist." | Out-String
            continue
        }
        disableAUser $name
        Write-Host "User: $name Disabled." | Out-String
    }

    elseif($choice -eq 7){
        $name = Read-Host -Prompt "Please enter the username for the user logs"
        if(-not (checkUser $name)){
            Write-Host "User does not exist." | Out-String
            continue
        }
        $days = Read-Host -Prompt "Enter how many days back to check logs"
        $userLogins = getLogInAndOffs $days
        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }

    elseif($choice -eq 8){
        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
        if(-not (checkUser $name)){
            Write-Host "User does not exist." | Out-String
            continue
        }
        $days = Read-Host -Prompt "Enter how many days back to check logs"
        $userLogins = getFailedLogins $days
        Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }

    elseif($choice -eq 9){
        $days = Read-Host -Prompt "Enter how many days back to check for failed logins"
        $failed = getFailedLogins $days
        $grouped = $failed | Group-Object User | Where-Object { $_.Count -gt 10 }

        if($grouped.Count -eq 0){
            Write-Host "No users with more than 10 failed logins." | Out-String
        } else {
            Write-Host "At Risk Users:" | Out-String
            foreach($g in $grouped){
                Write-Host "$($g.Name) - $($g.Count) failed logins" | Out-String
            }
        }
    }

    else {
        Write-Host "Invalid choice. Please enter a number from the menu." | Out-String
    }
}
