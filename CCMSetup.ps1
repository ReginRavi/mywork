$hash=@()
$anotherhash=@()
$filecontents = get-content "C:\Windows\ccmsetup\Logs\ccmsetup.log" 

$hash=$filecontents  -match  "CcmSetup is exiting with return code"  
$sheetName = "ExitCodes"
$file = "C:\Users\raviregi\Desktop\Book1.xlsx";$counter = 0
$objExcel = New-Object -ComObject Excel.Application
$workbook = $objExcel.Workbooks.Open($file)
$sheet = $workbook.Worksheets.Item($sheetName)
$sheet1 = $workbook.worksheets.Add()
$diskSpacewksht= $workbook.Worksheets.Item(1)
$diskSpacewksht.Name = "Result"

$objExcel.Visible=$false
$objExcel.Visible = $true

$rowMax = ($sheet.UsedRange.Rows).count

$rowid,$colid = 1,1
$rowAge,$colAge = 1,3
$rowCity,$colCity = 1,4
foreach ($has in $hash) {
  
    $anotherhash=$has -split " " | % { $_.trim()}
    #$anotherhash
  $val=  $anotherhash[6] |% { $_[0] }
        $counter++
        $val
        for ($i=1; $i -le $rowMax-1; $i++)
        {
            $id= $sheet.Cells.Item($rowid+$i,$colid).text
        if ($val -eq [string]$id) {
            $id1= $sheet.Cells.Item($rowid+$i,$colid).text 
            #$rowid+$i
            #$sheet.Cells.Item($rowid+$i,$colid+2).text 
            Write-Host ("Exit id: "+$id1)
            $sheet1.cells.Item($counter,1) = $val
        }
        
        }
    }






#([regex]::matches($anotherhash[1], '\w*="\w*"$') | %{$_.value})
#([regex]::matches($anotherhash[2], '\w*="\w*"$') | %{$_.value}) 
#[regex]::matches($anotherhash[1],'.+?(?<=\").+?(?=\")').value 
#[regex]::matches($anotherhash[2],'.+?(?<=\").+?(?=\")').value 



<#$another='ProgramID="Collect Mapped Drives - ADMIN"'
([regex]::matches($another, '?<=\"') | %{$_.value})

[regex]::matches($another,'.+?(?<=\").+?(?=\")').value #>






#$counter = 0
<#
Get-Service |

ForEach-Object {

    $counter++

    $sheet1.cells.Item($counter,1) = $_.Name
#
    $sheet1.cells.Item($counter,2) = $_.DisplayName

    $sheet1.cells.Item($counter,3) = $_.Status

}

#>

$objExcel.quit()