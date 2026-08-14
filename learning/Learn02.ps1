$ComputerName = $env:ComputerName

Write-Host "Ime računalnike: $ComputerName"

Get-Process | 
    Sort-Object CPU -Descending |
    Select-Object -First 5 Name, CPU