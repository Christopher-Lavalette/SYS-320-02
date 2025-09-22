function Get-ApacheLogs {
    param (
        [string]$Page,       # A) Page visited or referred from
        [string]$HttpCode,   # B) HTTP code returned
        [string]$Browser     # C) Web browser name
    )

    # Path to Apache access log
    $logPath = "C:\xampp\apache\logs\access.log"

    # Step 1: Read the log file
    $records = Get-Content $logPath

    # Step 2: Filter by all three conditions
    $filtered = $records | Where-Object {
        ($_ -match $Page) -and
        ($_ -match $HttpCode) -and
        ($_ -match $Browser)
    }

    # Step 3: Parse each log entry in a very simple way
    $tabRecords = foreach ($line in $filtered) {
        # Split the line by spaces
        $words = $line -split " "

        # Build a record object step by step
        $obj = [pscustomobject]@{
            IP       = $words[0]
            Time     = $words[3] + " " + $words[4]
            Method   = $words[5].Replace('"', "")
            Page     = $words[6]
            Protocol = $words[7].Replace('"', "")
            HttpCode = $words[8]
            Bytes    = $words[9]
            Referrer = $words[10].Replace('"', "")
            Browser  = ($words[11..($words.Length - 1)] -join " ")
        }

        # Send the object back
        $obj
    }

    # Step 4: Return the parsed records
    return $tabRecords
}
