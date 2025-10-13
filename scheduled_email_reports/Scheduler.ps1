#Sys-320, Christopher Lavalette
function ChooseTimeToRun($time) {
    $taskName = "myTask"
    $scriptPath = Join-Path $PSScriptRoot "main.ps1"

    # Remove old task if it exists
    $scheduledTasks = Get-ScheduledTask | Where-Object { $_.TaskName -eq $taskName }
    if ($scheduledTasks) {
        Write-Host "The task already exists. Removing old task..." -ForegroundColor Yellow
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }

    Write-Host "Creating new scheduled task..." -ForegroundColor Cyan

    # Action: run main.ps1 with full path and unrestricted execution
    $action = New-ScheduledTaskAction -Execute "powershell.exe" `
        -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""

    # Trigger: Daily at configured time
    $trigger = New-ScheduledTaskTrigger -Daily -At $time

    # Principal: run as the current user
    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest

    # Settings: run even if network is unavailable, starts if missed
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
                 -StartWhenAvailable -RunOnlyIfNetworkAvailable

    # Register task
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger `
        -Principal $principal -Settings $settings

    Write-Host "Scheduled task '$taskName' created for $time." -ForegroundColor Green
}

