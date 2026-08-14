$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
#$x = Read-Host "Predlagano nahajanje datoteke||| $scriptPath\ObjLang.csv"
$x = "$scriptPath\ObjLang.csv"
#$y = Read-Host "Predlagano shranjevanje datoteke||| $scriptPath\BacNet_v01.csv"
$y = "$scriptPath\BacnetIOs.csv"

$data = foreach($line in Get-Content $x)
{
if($line -like '*0x010D*')
{
$line
}
else
{
}

}

$data | Set-Content "$y" -Force

(Get-Content -Path "$y") |

ForEach-Object {$_ -Replace '0x010D', '0x8100'} |

Set-Content -Encoding Unicode -Path "$y"


$data = foreach($line in Get-Content $y)
{
if($line -like '*.cmd*' -or $line -like '*.Val*')
{
$line
}
else
{
}

}


 $data | Set-Content -Encoding Unicode -Path "$y" -Force



