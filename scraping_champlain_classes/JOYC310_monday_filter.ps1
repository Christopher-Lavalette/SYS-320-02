. .\gatherclasses.ps1 2>$null

$classes |
    Where-Object { $_.Location -like "*JOYC*310*" -and $_.Days -match "Monday" } |
    Sort-Object "Time Start" |
    Select-Object "Time Start", "Time End", "Class Code" |
    Format-Table -AutoSize