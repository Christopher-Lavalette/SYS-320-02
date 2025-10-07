function Get-ApacheLogs {
    param (
        [string]$Page,       # A) Page visited or referred from
        [string]$HttpCode,   # B) HTTP code returned
        [string]$Browser     # C) Web browser name
    )

    # Path to Apache access log
    $logPath = "C:\xampp\apache\logs\access.log"

    # Regex for IP addresses
    $regex = "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"

    # Step 1: Read the log file
    $records = Get-Content $logPath

    # Step 2: Filter by all three conditions
    $filtered = $records | Where-Object {
        ($_ -match $Page) -and
        ($_ -match $HttpCode) -and
        ($_ -match $Browser)
    }

    # Step 3: Extract IPs
    $ipsUnorganized = foreach ($line in $filtered) {
        if ($line -match $regex) { $matches[0] }
    }

    # Step 4: Group IPs and add metadata
    $ipsUnorganized | Group-Object | ForEach-Object {
        [pscustomobject]@{
            Count    = $_.Count
            IP       = $_.Name
            Page     = $Page
            HttpCode = $HttpCode
            Browser  = $Browser
        }
    }
}
