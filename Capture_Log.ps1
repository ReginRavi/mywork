# =============================================================================
# File:     OSDResult.ps1
# Version:  1.00
# Date:     19 August 2017
# Author:   Mike Marable
#
# Purpose: Tallys success vs. failure of build results in a CSV on the network
#
 
# =============================================================================
# Initialization
param ([string]$Record = $(throw "-Record is required [Start/Success/Failure]."))
 
# =============================================================================# Functions
#--------------------------------------
Function Get-SmstsFailAction
#--------------------------------------
{
Param ($SmstsLogPath)
$LogContents = $null
$FailedActionsIndexArray = $null
$strLastFailAction = $null
$LogContents = Get-Content -Path
$SmstsLogPath -ReadCount 0
Try
{
$FailedActionsIndexArray = @(0..($LogContents.Count - 1) | where {$LogContents[$_] -match "Failed to run the action"})
$strLastFailAction = (($LogContents[($FailedActionsIndexArray[-1])].tostring())-replace '.*\[LOG\[') -replace 'Failed to run the action: ' -replace '\]LOG\].*'
}
Catch
{
$strLastFailAction = "Unkown"
}
Return $strLastFailAction
}
#end function Get-SmstsFailAction
 
# =============================================================================# Start of Code
# Set Variables
$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$MyVersion = "1.00"
$myScript = "OSDResults"
$CSVfileName = "OSDResultsTally.csv"
$TargetFolder = $tsenv.Value("OSDResultsShare")
$OutPut = "$TargetFolder\Data"
$CSVFile = "$OutPut\$CSVfileName"
$SMSTSfldr = $tsenv.Value("_SMSTSLogPath")
$SMSTSfile = "$SMSTSfldr\smsts.log"
Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
"Write-Host "Starting $MyScript (v $MyVersion)
"Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
IF ($Record -eq "Start")
{
# Record the starting date and time for this build
Write-Host "Recording the starting date and time for this build"
$tsenv.Value("OSDStartInfo") = (Get-Date -Format "dd-MMM-yyyy HH:mm:ss")
Write-Host "This build began on: " $tsenv.Value("OSDStartInfo")
Write-Host "Recording the model of computer being built..."
$tsenv.Value("OSDModelInfo") = (Get-WmiObject -Class Win32_ComputerSystem).Model
Write-Host "This model: " $tsenv.Value("OSDModelInfo")
}
 
IF ($Record -eq "Success" -OR $Record -eq "Failure")
 {
 # Record the results for this build
 Write-Host "Recording the results for this build"
 $OSDFinishInfo = (Get-Date -Format "dd-MMM-yyyy HH:mm:ss")
 # Gather up the data to include in the report
 $OSDStartInfo = $tsenv.Value("OSDStartInfo")
 $OSModelInfo = $tsenv.Value("OSDModelInfo")
 $TSName = $tsenv.Value("_SMSTSPackageName")
 # Calculate the elapsed build runtime
 $TimeDiff = New-TimeSpan -Start $OSDStartInfo -End $OSDFinishInfo
 # Break the elapsed time down into units
 $Days = $TimeDiff.Days
 $Hrs = $TimeDiff.Hours
 $Mins = $TimeDiff.Minutes
 $Sec = $TimeDiff.Seconds
 # Boil it all down into the number of minutes the build took
 # Days (just in case)
 IF ($Days -gt 0) {$dMins = ($Days * 24) * 60}
 # Hours
 IF ($Hrs -gt 0) {$hMins = $Hrs * 60}
 # Seconds into a fraction of a minute
 $mSec = $Sec / 60
 # Limit to 2 decimal places
 $mSec = "{0:N2}" -f $mSec
 # Add it all up to get the number of minutes the build took
 $ElapsedTime = $TimeDiff.TotalMinutes
 $ElapsedTime = "{0:N2}" -f $ElapsedTime
 $ElapsedTime = $ElapsedTime -replace '[,]'
 # Write all of the results data to the master CSV
 Add-Content -Value "$env:COMPUTERNAME," -Path $CSVfile -NoNewline
 Add-Content -Value "$OSDStartInfo," -Path $CSVfile -NoNewline
 Add-Content -Value "$OSDFinishInfo," -Path $CSVfile -NoNewline
 Add-Content -Value "$OSModelInfo," -Path $CSVfile -NoNewline
 Add-Content -Value "$TSName," -Path $CSVfile -NoNewline
 Add-Content -Value "$Record," -Path $CSVfile -NoNewline
Add-Content -Value "$ElapsedTime," -Path $CSVfile -NoNewline
 
# If it was a failed build, find the reason in the SMSTS log and record it
IF ($Record -eq "Failure")
{
$SmstFailAction = Get-SmstsFailAction $SMSTSfile
Add-Content -Value "$SmstFailAction" -Path $CSVfile
}
 
IF ($Record -eq "Success")
{
# We'll record "success" in the failure reason so as not to cause problems with reporting
Add-Content -Value "Success" -Path $CSVfile
}
}
 
# =============================================================================
Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
Write-Host "Finished $MyScript (v $MyVersion)"
Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
# Finished
# =============================================================================