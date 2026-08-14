$wshell = New-Object -ComObject WScript.Shell

$wshell.Popup(
    "PowerShell script is starting.",
    3,
    "PowerShell",
    64
)

try {


$InputFile = Join-Path $PSScriptRoot "ObjLang.csv"
$OutputFileBacNetMembers = Join-Path $PSScriptRoot "bacNetMember.csv"

if (-not (Test-Path $InputFile)) {
    throw "File not found: $InputFile"
}

Write-Host "All input files found."




if (Test-Path -LiteralPath $OutputFileBacNetMembers) {
    Remove-Item -literalPath $OutputFileBacNetMembers -Force
    Write-Host "Old BacNetMembers ouput file delated."
}

Write-Host "Sleep for 5 sek."
Start-Sleep -Seconds 5

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

$NamesToRemove = @(
    "_En"
    )    

$membersToRemove = @(
    "0x0026",
    "0x0025",
    "0x002F",
    "0x2308",
    "0x2309",
    "Config",
    "Hw",
    "POL908",
    "Enbl"
)

$membersException = @(
    "Alarm",
    "ComAlmAck",
    "AlmPrio"
)

$data = Import-Csv @importParameters

$output = $data |
    Where-Object {
        $idMatches = $false

        foreach ($value in $IDsToAdd) {
            if ($_.ID -like "*$value*") {
                $idMatches = $true
                break
            }
        }

        $IDMatches 
    } 

$output = $output |
    Where-Object {
        $member = $_.Member
        $exceptionMatches = $false

        foreach ($value in $membersException) {
            if ($member -like "*$value*") {
                $exceptionMatches = $true
                break
            }
        }

        if ($exceptionMatches) {
            return $true
        }
        $removeMatches = $false

        foreach ($value in $membersToRemove) {
            if ($member -like "*$value*") {
                $removeMatches = $true
                break
            }
        }

        return (-not $removeMatches)

    }

$output = $output |
    Where-Object {
        $name = $_.Name

        -not (
            $NamesToRemove | 
                Where-Object {
                    $name -like "*$_*"
                }
        )
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
    Set-Content -Path $OutputFileBacNetMembers -Encoding utf8

Write-Host "Found $(@($data).Count) lines in ObjLang file."
Write-Host "Create $(@($output).Count) members in bacNet file."
Write-Host "Ouput file: $OutputFileIOs"

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