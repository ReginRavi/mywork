$sourcepath=""
$jobfunc= {
    Function ClientInstall {
$ErrorActionPreference ="silentlyContinue"
#copy-item $sourcepath "\\$_\c$\windows\temp" -Force -Recurse 
#$newProc=([WMICLASS]"\\$_\root\cimv2:win32_Process").Create("C:\windows\temp\$packageinstall")

#If ($newProc.ReturnValue -eq 0) { Write-Host $_ $newProc.ProcessId } else { write-host $_ Process create failed with $newProc.ReturnValue }
write-host "output"
}
}
start-job -name "Client1" -ScriptBlock {ClientInstall} -InitializationScript $jobfunc  |Wait-Job | Receive-Job -errorVariable errorMsg

if ($errorMsg){
    write-host $errorMsg.Message

}
$files= "c:\500MB.zip"
    $servers =  get-content "c:\servers.txt"
    $Jobs = @()
    $sb = {
           Param ($Server, $files)
           xcopy $files \\$Server\C$ /Y
          }

    foreach($server in $servers)
    {
        $Jobs += start-job -ScriptBlock $sb -ArgumentList $server, $files
    }
    $Jobs | Wait-Job | Remove-Job