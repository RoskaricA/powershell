$wshell = New-Object -ComObject WScript.Shell

$wshell.Popup(
    "PowerShell script is starting.",
    3,
    "PowerShell",
    64
)

try {

$InputFile = Join-Path $PSScriptRoot "ObjLang.csv"
$InputFileHierDesc = Join-Path $PSScriptRoot "AermecReg.csv"
$OutputFileHier = Join-Path $PSScriptRoot "Hierarchy.csv"


if (-not (Test-Path $InputFile)) {
    throw "File not found: $InputFile"
}

if (-not (Test-Path $InputFileHierDesc)) {
    throw "File not found: $InputFileHierDesc"
}

if (Test-Path -LiteralPath $OutputFileHier) {
    Remove-Item -literalPath $OutputFileHier -Force
    Write-Host "Old Hierarchy ouput file delated."
}

Write-Host "Input files found."

Write-Host "Sleep for 8 secunds"
start-sleep -Seconds 8


$descHeaders = @("Name","Desc")

$desData = @{
    Path      = $InputFileHierDesc
    Delimiter = ";"
    Header    = $descHeaders
}

$descData = Import-Csv @desData

# Ustvari lookup tabelo: Name -> Desc
$descDatalookup = @{}

foreach ($item in $descData) {
    $name = ([string]$item.Name).Trim()
    If ($name -ne "") {
        $descdataLookup[$name] = [string]$item.Desc
    }
}
   
$headers = @("Member","ID","Name","Desc","4","5","6","7","8","9","10")

$inputData = @{
    Path      = $InputFile
    Delimiter = "`t"
    Header    = $headers
}

$data = Import-Csv @inputData

# Poišči ujemajoča imena in obdrži samo ujemajoče vrstice
$output = foreach ($row in $data) {
    $name = ([string]$row.Name).Trim()

    if ($descDataLookup.ContainsKey($name)) {
        $newRow = $row.PSObject.Copy()
        $description = $descDataLookup[$name]

    $newRow.Desc = $description
    $newRow."4" = $description
    $newRow."5" = $description
    $newRow."6" = $description
    $newRow."7" = $description
    $newRow."8" = $description
    $newRow."9" = $description
    $newRow."10" = $description
  
    # Vrni samo vrstice, kjer je bilo najdeno ujemanje
    $newRow
    }
}

# Izvoz brez headerja
$exportFile = @{
    Delimiter         = "`t"
    NoTypeInformation = $true
}

$output | 
    ConvertTo-Csv @exportFile |
    Select-Object -Skip 1 |
    Set-Content -Path $OutputFileHier -Encoding utf8
   
Write-Host "Found $(@($output).Count) eq. lines. Create $OutputFileHier"

start-sleep -Seconds 8
Write-Host "Sleep for 8 secunds"


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