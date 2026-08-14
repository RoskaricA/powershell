
$InputFile = ".\ObjLang.csv"
$OutputFile = ".\IO.csv"

$headers = @("Member","ID","Name","Desc","4","5","6","7","8","9","10")

$data = Import-Csv `
    -Path $InputFile `
    -Delimiter "`t" `
    -Header $headers

$output = $data |
    Where-Object {
        $_.ID -eq "0x010D"
    }


 $output | 
    Export-Csv `
    -Path $OutputFile `
    -Delimiter "`t" `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "Found $(@($output).Count) lines."
Write-Host "Ouput file: $OutputFile"

