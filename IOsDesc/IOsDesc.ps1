# please add some comments

$wshell = New-Object -ComObject WScript.Shell

$wshell.Popup(
    "PowerShell script is starting.",
    3,
    "PowerShell",
    64
)

try {

$InputFile = Join-Path $PSScriptRoot "ObjLang.csv"
$InputFileIOs = Join-Path $PSScriptRoot "IOs.csv"

$OutputFileIOsDesc = Join-Path $PSScriptRoot "IOsDesc.csv"
$OutputFileIOsBacNet = Join-Path $PSScriptRoot "IOsBacNet.csv"



if (-not (Test-Path $InputFile)) {
    throw "File not found: $InputFile"
}

Write-Host "Inpot ObjLang file: $InputFile present"

if (-not (Test-Path $InputFileIOs)) {
    throw "File not found: $InputFileIOs"
}

Write-Host "Inpot IOs file: $InputFileIOs present"

if (Test-Path -LiteralPath $OutputFileIOsDesc) {
    Remove-Item -literalPath $OutputFileIOsDesc -Force
    Write-Host "Old IOs output file delated."
}

if (Test-Path -LiteralPath $OutputFileIOsBacNet) {
    Remove-Item -literalPath $OutputFileIOsBacNet -Force
    Write-Host "Old BacNetIOs ouput file delated."
}


Write-Host "Sleep for 10 sek."
Start-Sleep -Seconds 10


$descHeaders = @("Name","Desc")

$desData = @{
    Path      = $InputFileIOs
    Delimiter = ";"
    Header    = $descHeaders
}

$descData = Import-Csv @desData


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

$outputBacNet = foreach ($row in $output)
{
    $newRow = $row.PSObject.Copy()
    $newRow.ID = $newRow.ID.Replace($oldMember, $newMember)
    $newRow
}    


$descDatalookup = @{}

foreach ($item in $descData) {
    $name = $item.Name.Trim()
    $descdataLookup[$name] = $item.Desc
}

$output = foreach ($row in $output) {
    $newRow = $row.PSObject.Copy()
    $name = $newRow.Name.Trim()

    if ($descDataLookup.ContainsKey($name)) {
        $newRow.Desc = $descDataLookup[$name]
    }

    $newRow
}

$output = foreach ($row in $output) {
    $newRow = $row.PSObject.Copy()
    $name = $newRow.Name.Trim()

    if ($descDataLookup.ContainsKey($name)) {
        $description = $descDataLookup[$name]

        $newRow.Desc = $description
        $newRow."4" = $description
        $newRow."5" = $description
        $newRow."6" = $description
        $newRow."7" = $description
        $newRow."8" = $description
        $newRow."9" = $description
        $newRow."10" = $description
    }

    $newRow
}


$exportFile = @{
    Delimiter         = "`t"
    NoTypeInformation = $true
}

$output | 
    ConvertTo-Csv @exportFile |
    Select-Object -Skip 1 |
    Set-Content -Path $OutputFileIOsDesc -Encoding utf8


$outputBacNet | 
    ConvertTo-Csv @exportFile |
    Select-Object -Skip 1 |
    Set-Content -Path $OutputFileIOsBacnet -Encoding utf8    

Write-Host "Found $(@($output).Count) lines."
Write-Host "Ouput file: $OutputFileIOsDesc created."

Write-Host "Ouput file: $OutputFileIOsbacNet created."

Start-Sleep -Seconds 5


$data = Import-Csv @importParameters -ErrorAction Stop

    $wshell.Popup(
        "Script finished successfully.",
        5,
        "Hierarchy processing",
        64
    )
}
catch {
    $wshell.Popup(
        "Script failed:`n$($_.Exception.Message)",
        0,
        "Hierarchy processing - ERROR",
        16
    )

    throw
}


$wshell.Popup(
    "Script finished successfully.",
    5,
    "PowerShell",
    64
)
