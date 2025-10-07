# Christopher Lavalette, SYS 320
# String Helper Functions

function getMatchingLines($contents, $lookline){

$allines = @()
$splitted =  $contents.split([Environment]::NewLine)

for($j=0; $j -lt $splitted.Count; $j++){  
   if($splitted[$j].Length -gt 0){  
        if($splitted[$j] -ilike $lookline){ $allines += $splitted[$j] }
   }
}

return $allines
}

function checkPassword($passwordString){

    $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordString))

    if($plain.Length -lt 6){ return $false }

    $hasLetter = $plain -match "[A-Za-z]"
    $hasNumber = $plain -match "[0-9]"
    $hasSpecial = $plain -match "[^A-Za-z0-9]"

    if($hasLetter -and $hasNumber -and $hasSpecial){
        return $true
    } else {
        return $false
    }
}
