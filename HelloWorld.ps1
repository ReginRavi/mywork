$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
write-host "Started at $(get-date)"
sleep 20
write-host "Ended at $(get-date)"
write-host "Total Elapsed Time: $($elapsed.Elapsed.ToString())"