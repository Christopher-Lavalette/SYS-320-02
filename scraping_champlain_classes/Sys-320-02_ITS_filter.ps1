. .\gatherclasses.ps1 2>$null


$validPrefixes = "SYS","NET","SEC","FOR","CSI","DAT"

$ITSInstructors = $classes |
    Where-Object {
        $prefix = $_."Class Code".Split(" ")[0]
        $validPrefixes -contains $prefix
    } |
    Select-Object -Property Instructor -Unique |
    Sort-Object Instructor

$ITSInstructors | Format-Table -AutoSize
