. .\gatherclasses.ps1 2>$null

$classes |
    Group-Object -Property Instructor |
    Select-Object @{Name='Count'; Expression={$_.Count}}, 
                  @{Name='Instructor'; Expression={$_.Name}} |
    Sort-Object Count -Descending |
    Format-Table -AutoSize
