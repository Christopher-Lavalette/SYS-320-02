# Christopher Lavalette, SYS 320
# Chrome Launch Script

function startChrome(){

    $chromeRunning = Get-Process | Where-Object { $_.ProcessName -ilike "chrome" }

    if($chromeRunning){
        Write-Host "Chrome is already running." | Out-String
    }
    else{
        Start-Process "chrome.exe" "https://www.champlain.edu"
        Write-Host "Chrome started and navigated to champlain.edu" | Out-String
    }
}
