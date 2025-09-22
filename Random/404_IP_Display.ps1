# Get only logs that contain 404, save into $notfounds
$notfounds = Get-Content C:\xampp\apache\logs\access.log | Select-String '404'

# Define a regex for IP addresses
$regex = "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"

# Get $notfounds records that match to the regex
$ipsunorganized = foreach ($line in $notfounds) { if ($line -match $regex) { $matches[0] } }

# Get IPs as pscustomobject
$ips = for ($i = 0; $i -lt $ipsunorganized.count; $i++) { 
    [pscustomobject]@{ IP = $ipsunorganized[$i] } 
}

$ips
