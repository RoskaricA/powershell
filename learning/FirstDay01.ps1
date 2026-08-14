# create a file
# New-Item -path .\Test.csv -ItemType File
# Set-Content -Path .\Text.csv -Value "My first content"
# New-Item -Path .\Reports -ItemType Directory
# $NameLoc = Get-Location
# Write-Host $NameLoc
# Get-Childitem -Recurse *.ps1
# $Mylocation = Get-Childitem -Directory
# Write-Host $Mylocation


$InputFile = ".\ObjLang.csv"
# $OutputFile = ".\IO.csv"
# $lines = Get-Content $InputFile
# $lines | Select-Object -First 3

$headers = @("Member","ID","Name","Desc","4","5","6","7","8","9","10")

$data = Import-Csv -Path $InputFile -Delimiter "`t" -Header $headers
foreach ($row in $data) {
    $data | Where-Object {$_.ID -like "0x0100"}
    Write-Host "$($row.ID) - $($row.Name)"
}
$data[500].Name

