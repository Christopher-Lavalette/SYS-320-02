# Sys-320-02
# Christopher Lavalette
# Functions and Event Logs Script 1
# 9/15/2025
function Get-LogonLogoffEvents {
    param (
        [int]$Days
    )

    # Get logon and logoff records from Windows Event Log (for the given number of days)
    $logonouts = Get-EventLog -LogName Security -After (Get-Date).AddDays(-$Days)

    $logonoutsTable = @()

    for ($i=0; $i -lt $logonouts.Count; $i++) {
        if ($logonouts[$i].InstanceId -eq 4648) { $event = "Logon" }
        elseif ($logonouts[$i].InstanceId -eq 4647) { $event = "Logoff" }
        else { continue }   # skip anything else

        try {
            # Translate SID from ReplacementStrings[5] to Username
            $sid = New-Object System.Security.Principal.SecurityIdentifier($logonouts[$i].ReplacementStrings[5])
            $user = $sid.Translate([System.Security.Principal.NTAccount]).Value
        } catch {
            # Ignore if translation fails
            $user = $logonouts[$i].ReplacementStrings[5]
        }

        $logonoutsTable += [PSCustomObject]@{
            Time  = $logonouts[$i].TimeGenerated;
            Id    = $logonouts[$i].InstanceId;
            Event = $event;
            User  = $user;
        }
    }

    return $logonoutsTable
}

# Example usage of script:
# Get-LogonLogoffEvents -Days 14
