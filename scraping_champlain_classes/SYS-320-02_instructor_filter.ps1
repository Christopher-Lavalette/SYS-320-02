. .\gatherclasses.ps1 2>$null
# Filtered List will appear at the bottom, below the main lisitng of all the classes
$classes | Where-Object {$_.Instructor -eq "Furkan Paligu" } | Select-Object "class code", Instructor, Location, Days, "Time Start", "Time End" | Format-Table -AutoSize