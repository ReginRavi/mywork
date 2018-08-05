$sch_Time="10:08 PM"

Function Schedule_Time ($sch_Time) {
     Write-host "Scheduled to Run at $sch_Time"
    $seconds=(New-TimeSpan -End $sch_Time).TotalSeconds
    $seconds
    
    if ([int]$seconds -ge 0){
        Sleep -Seconds  $seconds
        WRITE-HOST "bOOM"
    }

    else{
       $Scheduled_Seconds= [math]::abs($seconds)
       #Sleep -Seconds $Scheduled_Seconds
        write-host "Passed the time "
    }
}

Schedule_Time $sch_Time

[System.TimeZone]::CurrentTimeZone
$utctime = [datetime]::Now.ToUniversalTime()
$utctime.ToLocalTime()



[System.TimeZone]::CurrentTimeZone.ToLocalTime('Mon, 07 Jul 2014 18:00:22 +0000')

[System.TimeZone]::CurrentTimeZone.ToLocalTime('Wednesday, February 7, 2018 8:26:44 PM GMT')

Switch ((get-date).tostring('tt')) 
 {
   'AM' {'Morning script'}
   'PM' {'Afternoon script'}
 }

-1*-1
[math]::abs(-1)