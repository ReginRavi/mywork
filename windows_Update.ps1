$strcomp="localhost"
$Session=[activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$strcomp))
#$Session = New-Object -ComObject ("Microsoft.Update.Session" ,$strcomp)
$Searcher = $Session.CreateUpdateSearcher()
$HistoryCount = $Searcher.GetTotalHistoryCount()
$a=@()
$a=$Searcher.QueryHistory(0,$HistoryCount) | ForEach-Object {$_} | Sort-Object Date -Descending | ft  #ft | OUT-FILE C:\OUTPUT.csv
$a

$computerlist=Get-content "C:\computers.txt"

foreach ($strcomp in $computerlist )
{
$objSession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$strcomp))
$objSearcher= $objSession.CreateUpdateSearcher()
$totalupdates = $objSearcher.GetTotalHistoryCount()
$obj=$objSearcher.QueryHistory(0,$totalupdates) | ForEach-Object {$_.Title} | Sort-Object Date -Descending | Select-Object -First 1  #| out-file "C:\output.txt" -Append
$obj
<#
$FinalResult += New-Object psobject -Property @{
    ServerName = $strcomp
    Result = $obj
    }
    $FinalResult #>
}
(get-service  -Name CcmExec).Stop()