function gatherClasses {
    $page = Invoke-WebRequest -TimeoutSec 2 http://10.0.17.15/Courses2025FA.html
    $trs  = $page.ParsedHtml.getElementsByTagName("tr")

    $FullTable = @()
    for ($i = 1; $i -lt $trs.length; $i++) {
        $tds = $trs[$i].getElementsByTagName("td")
        $Times = $tds[5].innerText.Split("-")

        # Days translator
        $rawDays = $tds[4].innerText.Trim()
        $Days = @()

        # If you see "M" -> Monday
        if($rawDays -ilike "*M*"){ $Days += "Monday" }

        # If you see "T" followed by T,W, or F -> Tuesday
        if($rawDays -ilike "*T[WF]*"){ $Days += "Tuesday" }
        # If you only see "T" -> Tuesday
        elseif($rawDays -ilike "*T*"){ $Days += "Tuesday" }

        # If you see "W" -> Wednesday
        if($rawDays -ilike "*W*"){ $Days += "Wednesday" }

        # If you see "Th" -> Thursday
        if($rawDays -ilike "*Th*"){ $Days += "Thursday" }

        # If you see "F" -> Friday
        if($rawDays -ilike "*F*"){ $Days += "Friday" }

        # Replace original days with translated ones
        $tds[4].innerText = ($Days -join ", ")

        $FullTable += [PSCustomObject]@{
            "Class Code" = $tds[0].innerText.Trim()
            "Title"      = $tds[1].innerText.Trim()
            "Credit"     = $tds[2].innerText.Trim()
            "Seats"      = $tds[3].innerText.Trim()
            "Days"       = $tds[4].innerText
            "Time Start" = $Times[0].Trim()
            "Time End"   = $Times[1].Trim()
            "Instructor" = $tds[6].innerText.Trim()
            "Location"   = $tds[9].innerText.Trim()
        }
    }
    return $FullTable
}

# Run the function to test
$classes = gatherClasses
$classes | Format-List
