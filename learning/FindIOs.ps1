
$InputFile = ".\ObjLang.csv"
$OutputFileIOs = ".\IOs.csv"


$headers = @("Member","ID","Name","Desc","4","5","6","7","8","9","10")

$oldMember = "0x010D"
$newMember = "0x8100"

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
        $memberMatches = $false
        $idMatches = $false

        foreach ($value in $membersToAdd) {
            if ($_.Member -like "*$value*") {
                        $memberMatches = $true
                        Break
            }
        }
    
        foreach ($value in $IDsToAdd) {
            if ($_.ID -like "*$value*") {
                $idMatches = $true
                break
            }
        }
        $memberMatches -and $IDMatches 
    } 

$output = foreach ($row in $output)
{
    $newRow = $row.PSObject.Copy()
    $newRow.ID = $newRow.ID.Replace($oldMember, $newMember)
    $newRow
}    

$exportFile = @{
    Delimiter         = "`t"
    NoTypeInformation = $true
}

$output | 
    ConvertTo-Csv @exportFile |
    Select-Object -Skip 1 |
    Set-Content -Path $OutputFileIOs -Encoding utf8


Write-Host "Found $(@($output).Count) lines."
Write-Host "Ouput file: $OutputFileIOs"
