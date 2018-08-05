$parameters2="/mp:CGTSCCM20015.S2.MS.UNILEVER.COM /mp:BRBSCCM20009.S2.MS.UNILEVER.COM SMSSITECODE=EU2 FSP=CGTSCCM20012.S2.MS.UNILEVER.COM"
$VerbosePreference = "Continue"
$ErrorActionPreference="Continue"
$CurrentDirectory="C:\Users\3RDP-ADMN-REGIN.RAVI\Desktop\Newfolder"
$filepath="$CurrentDirectory\Client_Reinstall.log"
$computers = get-content "$CurrentDirectory\Computers.txt"
function Write-Log
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("LogContent")]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [Alias('LogPath')]
        [string]$Path="$CurrentDirectory\Client_Reinsatll.log",
        
        [Parameter(Mandatory=$false)]
        [ValidateSet("Error","Warn","Info")]
        [string]$Level="Info",
        
        [Parameter(Mandatory=$false)]
        [switch]$NoClobber
    )

    Begin
    {
        $VerbosePreference = 'Continue'
    }
    Process
    {  
        if ((Test-Path $Path) -AND $NoClobber) {
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name."
            Return
            }

        elseif (!(Test-Path $Path)) {
            Write-Verbose "Creating $Path."
            $NewLogFile = New-Item $Path -Force -ItemType File
            }

        else {
           
            }
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        switch ($Level) {
            'Error' {
                Write-Error $Message
                $LevelText = 'ERROR:'
                }
            'Warn' {
                Write-Warning $Message
                $LevelText = 'WARNING:'
                }
            'Info' {
                Write-Verbose $Message
                $LevelText = 'INFO:'
                }
            }

        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append
    }
    End
    {
    }
}
#$ErrorActionPreference ="SilentlyContinue"

write-Log -Message "Working with the directory path $CurrentDirectory" -Path $filepath -Level Info
write-Log -Message "Getting Computers from $CurrentDirectory\Computers.txt" -Path $filepath -Level Info

$path1="$CurrentDirectory\ccmclean.exe"
$path2="$CurrentDirectory\ccmsetup.exe"
$parameters1="/ALL /q"
$packageinstall1=(split-path $path1 -leaf) + ' ' + $parameters1
$packageinstall2=(split-path $path2 -leaf) + ' ' + $parameters2
write-Log -Message $packageinstall1 -Path $filepath -Level Info
write-Log -Message $packageinstall2 -Path $filepath -Level Info
#$computers ="localhost"
ForEach($comp in $computers)
{
if (Test-Connection $comp -Quiet -count 1) {

    CCMReinstall $comp
}
else {
    " $comp Machine is offline"
}
}
Function CCMReinstall {
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $computername
    ) 

write-Log -Message "$comp is online and trying to connect C$" -Path $filepath -Level Info
$Copy1=copy-item $path1 "\\$comp\c$\windows\temp" -Force -Recurse -ErrorAction SilentlyContinue
$Copy2= copy-item $path2 "\\$comp\c$\windows\temp" -Force -Recurse -ErrorAction SilentlyContinue

if($copy1){
    write-Log -Message "Copied CCMClean and initiating removal using CCMClean /Q" -Path $filepath -Level Info
    $newProc1=([WMICLASS]"\\$comp\root\cimv2:win32_Process").Create("C:\windows\temp\$packageinstall1")
    If ($newProc1.ReturnValue -eq 0) { 
        write-Log -Message "$comp with processID $newProc1.ProcessId " -Path $filepath -Level Error
    } 
        else {
            write-Log -Message "$comp Process create failed with $newProc1.ReturnValue" -Path $filepath -Level Error
         }
    start-sleep -s 90
}
else {
    write-Log -Message "$comp Coping CCMClean failed" -Path $filepath -Level Error
}
if ($Copy2){
    write-Log -Message "Copied CCMSetup and initiating install with parameters $parameters2" -Path $filepath -Level Info
    $newProc2=([WMICLASS]"\\$comp\root\cimv2:win32_Process").Create("C:\windows\temp\$packageinstall2")
    If ($newProc2.ReturnValue -eq 0) {
        write-Log -Message "$comp with $newProc2.ProcessId" -Path $filepath -Level Info 
    } 
        else { write-Log -Message "$comp Process create failed with $newProc2.ReturnValue" -Path $filepath -Level Error
     }
}
else {
    write-Log -Message "$comp Coping CCMSetup failed " -Path $filepath -Level Error
}
}


Get-WmiObject -namespace root\cimv2\sms #-class SMS_InstalledSoftware