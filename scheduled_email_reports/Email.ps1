#Sys-320, Christopher Lavalette
# Email.ps1

function SendAlertEmail {
    param(
        [string]$Body
    )

    # --- Email setup ---
    $From    = "christopher.lavalett@mymail.champlain.edu"
    $To      = "christopher.lavalett@mymail.champlain.edu"
    $Subject = "Suspicious Activity"


    # --- Secure password ---
    # Replace the text inside < > with a Gmail App Password for the folder's scripts to function again!
    $Password   = "<FILLWITHAPPPASWORD!!!!!!!>" | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

    # --- Send the email ---
    try {
        Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body `
            -SmtpServer "smtp.gmail.com" -Port 587 -UseSsl -Credential $Credential

        Write-Host "Email successfully sent to $To" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to send email:" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

# Example manual test (uncomment to verify email works)
# SendAlertEmail "Test email from PowerShell”
