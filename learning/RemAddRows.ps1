
$InputFile = ".\ObjLang.csv"
$OutputFileAdd = ".\Add.csv"
$OutputFileRem = ".\Rem.csv"

$removeFileRem = @{
    Path    = $OutputFileRem
    Confirm = $true
}

$removeFileAdd = @{
    Path    = $OutputFileAdd
    Confirm = $true
}

$headers = @("Member","ID","Name","Desc","4","5","6","7","8","9","10")

$membersToAdd = @(
    "0x010D",
    "0x1000"
    )


    
$membersToRemove = @(
    "0x0026",
    "0x0025",
    "0x002F"
)

$importParameters = @{
    Path      = $InputFile
    Delimiter = "`t"
    Header    = $headers
}

$data = Import-Csv @importParameters

$outputAdd = $data |
    Where-Object {
        $member = $_.ID
        foreach ($value in $membersToAdd) {
            if ($member -like "*$value*") {
                return $true
            }
        }
        return $false
    } 

# $outputAdd = $outputAdd |
    # Select-Object Memert,ID,Name,Desc

$outputRem = $data |
    Where-Object {
        $member = $_.Member

        -not (
            $membersToRemove | 
                Where-Object {
                    $member -like "$_*"
                }
        )
    }


$exportFileAdd = @{
    Path              = $OutputFileAdd
    Delimiter         = "`t"
    NoTypeInformation = $true
    Encoding          = "UTF8"
}

$exportFileRem = @{
    Path              = $OutputFileRem
    Delimiter         = "`t"
    NoTypeInformation = $true
    Encoding          = "UTF8"
}

if (Test-Path -Path $OutputFileAdd) {
    Remove-Item @removeFileAdd
}

$outputAdd | Export-Csv @exportFileAdd

if (Test-Path -Path $OutputFileRem) {
    Remove-Item @removeFileRem
}
$outputRem | Export-Csv @exportFileRem



Write-Host "Found $(@($outputAdd).Count) lines."
Write-Host "Ouput file: $OutputFileAdd"



Write-Host "Found $(@($outputRem).Count) lines."
Write-Host "Ouput file: $OutputFileRem"