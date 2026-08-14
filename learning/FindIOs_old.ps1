
$InputFile = ".\ObjLang.csv"
$OutputFileIOs = ".\IOs.csv"

$headers = @("Member","ID","Name","Desc","4","5","6","7","8","9","10")

# $oldMember = "0x010D"
# $newMember = "0x8100"

$importParameters = @{
    Path      = $InputFile
    Delimiter = "`t"
    Header    = $headers
}

$IDsToAdd = @(
    "0x010D"
    )

$membersToAdd = @(
    "0x2203",
    "0x2204",
    "0x2206",
    "0x2207"
    )    


$data = Import-Csv @importParameters

$output = $data |
    Where-Object {
        $member = $_.Member
        write-host $member
        foreach ($value in $membersToAdd) {
            if ($member -like "*$value*") {
                return $true
            }
        }
        return $false
    } 

$output = $data |
    Where-Object {
        $member = $_.ID
        write-host $member
        foreach ($value in $IDsToAdd) {
            if ($member -like "*$value*") {
                return $true
            }
        }
        return $false
    } 


# $outputAdd = $outputAdd |
    # Select-Object Memert,ID,Name,Desc



$exportFile = @{
    Path              = $OutputFileIOs
    Delimiter         = "`t"
    NoTypeInformation = $true
    Encoding          = "UTF8"
}





$output | Export-Csv @exportFile





Write-Host "Found $(@($output).Count) lines."
Write-Host "Ouput file: $OutputFile"



