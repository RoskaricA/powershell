
$InputFile = ".\ObjLang.csv"
$OutputFile = ".\IO.csv"

$headers = @("Member","ID","Name","Desc","4","5","6","7","8","9","10")

$importParameters = @{
    Path      = $InputFile
    Delimiter = "`t"
    Header    = $headers
}

$data = Import-Csv @importParameters


$output = $data |
    Where-Object {
        $_.Member -like "*0x2308*"
    }


    $exportParameters = @{
    Path              = $OutputFile
    Delimiter         = "`t"
    NoTypeInformation = $true
    Encoding          = "UTF8"
}

$output | Export-Csv @exportParameters



Write-Host "Found $(@($output).Count) lines."
Write-Host "Ouput file: $OutputFile"

