        
        $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition 
        $TEMP=Read-Host "Vpi�i lokacijo datoteke primer: E:\test"
        $Z=$scriptPath + "\" + $TEMP
        $p = Read-Host "1.wildcard"
        $x = "$scriptPath\ObjLang.csv"
        $y = "$scriptPath\bacnet.csv"
        
        $O = "$scriptPath\KNtest.csv"

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

        $data | Set-Content -encoding Unicode "$y" -Force


        $data = foreach($line in Get-Content "$y")
    {
        if($line -LIKE "$p" )
    {
        $line
    }
        else
    {
    }

    }
        $data | Set-Content -encoding Unicode "$y" -Force

        (Get-Content -Path "$y") |

        ForEach-Object {$_ -Replace '	', ','} |

        Set-Content -Encoding Unicode -Path "$y" -Force

        @("1,2,3,4,5,6,7,8,9,10") +  (Get-Content "$y") | Set-Content "$y"

        (Get-Content -Path "$z") |

        ForEach-Object {$_ -Replace ';', ','} |

        Set-Content -Encoding Unicode -Path "$o" -Force
        $km=$p.Trimstart("*").Trimend("*")
        $kn=$p.Trimstart("*").Trimend("*")+ "."
        (get-content "$O") | foreach {"$kn" + $_ } | Set-Content "$o" -Force
         

        @("1,2") +  (Get-Content "$o") | Set-Content "$o" -Force


        
        
            $Y = Import-Csv $scriptPath\bacnet.csv 
            $X = Import-Csv $scriptPath\KNtest.csv 
            $C=0
            $L=0
            $P=$X.Count*$y.Count



         $post=for($L=0;$L -lt $x.Count)
    {
                if($Y[$C].3 -match $X[$L].1)
    { 
            
                $Y[$C].1,$Y[$C].2,$Y[$C].4,$Y[$C].4,$Y[$C].5,$X[$L].2,$X[$L].2,$X[$L].2,$X[$L].2,$X[$L].2-join','
                $L++
                $C=0
    }
                elseif($C-gt$y.Count)
    {
                $L++
                $C=0

    }

                else

    {
                $C++


    }
    }
    

            $post| Set-Content -Encoding Unicode  "$scriptPath\$km.csv" -Force

            (Get-Content -Path "$scriptPath\$km.csv") |

            ForEach-Object {$_ -Replace ',', '	'} |

            Set-Content -Encoding Unicode -Path "$scriptPath\$km.csv" -Force


            
            Remove-item -path $scriptPath\bacnet.csv
            Remove-item -path $scriptPath\KNtest.csv
            