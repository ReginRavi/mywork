#--------------------------------------------
# Hyper-V Event Channels
#--------------------------------------------
$HYPERV_EVENT_CHANNELS = @{
    "Compute" = @("Microsoft-Windows-Hyper-V-Compute-Admin",
                  "Microsoft-Windows-Hyper-V-Compute-Operational",
                  "Microsoft-Windows-Hyper-V-Compute-Analytic");

    "Config" = @("Microsoft-Windows-Hyper-V-Config-Admin",
                 "Microsoft-Windows-Hyper-V-Config-Analytic",
                 "Microsoft-Windows-Hyper-V-Config-Operational");

    "High-Availability" = @("Microsoft-Windows-Hyper-V-High-Availability-Admin",
                            "Microsoft-Windows-Hyper-V-High-Availability-Analytic");

    "Hypervisor" = @("Microsoft-Windows-Hyper-V-Hypervisor-Admin",
                     "Microsoft-Windows-Hyper-V-Hypervisor-Analytic",
                     "Microsoft-Windows-Hyper-V-Hypervisor-Operational");

    "StorageVSP" = @("Microsoft-Windows-Hyper-V-StorageVSP-Admin");

    "VID" = @("Microsoft-Windows-Hyper-V-VID-Admin",
              "Microsoft-Windows-Hyper-V-VID-Analytic");

    "VMMS" = @("Microsoft-Windows-Hyper-V-VMMS-Admin",
               "Microsoft-Windows-Hyper-V-VMMS-Analytic",
               "Microsoft-Windows-Hyper-V-VMMS-Networking",
               "Microsoft-Windows-Hyper-V-VMMS-Operational",
               "Microsoft-Windows-Hyper-V-VMMS-Storage");

    "VmSwitch" = @("Microsoft-Windows-Hyper-V-VmSwitch-Diagnostic",
                   "Microsoft-Windows-Hyper-V-VmSwitch-Operational");

    "Worker" = @("Microsoft-Windows-Hyper-V-Worker-Admin",
                 "Microsoft-Windows-Hyper-V-Worker-Analytic",
                 "Microsoft-Windows-Hyper-V-Worker-Operational",
                 "Microsoft-Windows-Hyper-V-Worker-VDev-Analytic");

    "SMB" = @("Microsoft-Windows-SMBClient/Connectivity",
              "Microsoft-Windows-SMBClient/Security",
              "Microsoft-Windows-SMBServer/Connectivity",
              "Microsoft-Windows-SMBServer/Security");

    "FailoverClustering" = @("Microsoft-Windows-FailoverClustering/Diagnostic",
                             "Microsoft-Windows-FailoverClustering/DiagnosticVerbose",
                             "Microsoft-Windows-FailoverClustering/Operational",
                             "Microsoft-Windows-VHDMP-Operational")
}

<#
.SYNOPSIS
    Returns the names of the event channels given the friendly name(s).

.DESCRIPTION
    Returns the names of the event channels given the friendly name(s).

.PARAMETER EventChannel
    Supplies the raw event channel names. These will be returned as-is.

.PARAMETER HyperVChannels
    Array with friendly names for common Hyper-V Channels.

.EXAMPLE
    Get-EventChannelList -HyperVChannels VMMS,Worker,Compute
#>
function Get-EventChannelList
{
    [CmdletBinding()]
    param(
        [string[]]$EventChannel,

        [ValidateSet('None', 'All', 'Compute', 'Config', 'High-Availability', 'Hypervisor', `
            'StorageVSP', 'VID', 'VMMS', 'VmSwitch', 'Worker', 'SMB', 'FailoverClustering')]
        [string[]]$HyperVChannels,

        [Boolean]$StripAdminChannels = $false
    )

    $eventChannels = @()

    if ($HyperVChannels -notcontains "None")
    {
        if ($HyperVChannels -contains "All")
        {
            foreach ($channel in $HYPERV_EVENT_CHANNELS.Keys)
            {
                $eventChannels += $HYPERV_EVENT_CHANNELS[$channel]
            }
        }
        else
        {
            foreach ($channel in $HyperVChannels)
            {
                $eventChannels += $HYPERV_EVENT_CHANNELS[$channel]
            }
        }
    }

    if ($EventChannel)
    {
        $eventChannels += $EventChannel
    }
    
    return $eventChannels
}

<#
.SYNOPSIS
    Enables event channels so that events are collected.

.DESCRIPTION
    Enables event channels so that events are collected and can later be written to a 
    consolidated file using Save-EventChannels.

.PARAMETER EventChannel
    Supplies the event channels that will be enabled.

.PARAMETER MaxSize
    Supplies the max size in bytes for the event channels.

.PARAMETER HyperVChannels
    Array with friendly names for common Hyper-V Channels. Defaults to None.

.PARAMETER PSSession
    Supplies an optional PSSession to run the cmdlet on. This is useful if you need to collect
    events logged on a remote session.

.EXAMPLE
    Enable-EventChannels -HyperVChannels VMMS,Worker,Compute
#>
function Enable-EventChannels
{
    [CmdletBinding()]
    param(
        [parameter(Position=0)]
        [string[]]$EventChannel,

        [parameter(Position=1)]
        [int64]$MaxSize=67108864,

        [ValidateSet('None', 'All', 'Compute', 'Config', 'High-Availability', 'Hypervisor', `
            'StorageVSP', 'VID', 'VMMS', 'VmSwitch', 'Worker', 'SMB', 'FailoverClustering')]
        [string[]]$HyperVChannels="All",

        [System.Management.Automation.Runspaces.PSSession]$PSSession
    )

    #-----------------------------------
    # Setup
    #-----------------------------------
    $eventChannels = Get-EventChannelList -EventChannel $EventChannel -HyperVChannels $HyperVChannels

    #------------------------------------------
    # ScriptBlock that enables event channels
    #------------------------------------------
    $enableEventsScriptBlock = {
        param(
            [string[]] $EventChannels,
            [int64] $MaxSize
        )

        foreach ($event in $EventChannels)
        {
            try
            {
                wevtutil set-log $event /enabled:false /quiet
                if ($LastExitCode -ne 0)
                {
                    Write-Error "Error: wevtutil failed to disable $event with error $LastExitCode."
                }
                else
                {
                    wevtutil set-log $event /maxsize:$MaxSize /quiet
                    if ($LastExitCode -ne 0)
                    {
                        Write-Error "Error: wevtutil failed to set max size on $event with error $LastExitCode."
                    }

                    wevtutil set-log $event /enabled:true /quiet
                    if ($LastExitCode -ne 0)
                    {
                        Write-Error "Error: wevtutil failed to enable $event with error $LastExitCode."
                    }
                }
            }
            catch
            {
                continue
            }
        }
    }

    #------------------------------------------
    # Enable event channels on target machine
    #------------------------------------------
    if (!$PSSession)
    {
        Invoke-Command -ScriptBlock $enableEventsScriptBlock -ArgumentList $eventChannels, $MaxSize
    }
    else
    {
        Invoke-Command -Session $PSSession -ScriptBlock $enableEventsScriptBlock -ArgumentList $eventChannels, $MaxSize
    }
}

<#
.SYNOPSIS
    Disable events channels.

.DESCRIPTION
    Disable events channels.

.PARAMETER EventChannel
    Supplies the event channels that will be disabled.

.PARAMETER HyperVChannels
    Array with friendly names for common Hyper-V Channels. Defaults to None.

.PARAMETER SkipAdminEventChannels
    Determines whether Admin channels should be skipped for disabling. Defaults to True.

.PARAMETER PSSession
    Supplies an optional PSSession to run the cmdlet on. This is useful if you need to collect
    events logged on a remote session.

.EXAMPLE
    Disable-EventChannels -HyperVChannels VMMS,Worker,Compute
#>
function Disable-EventChannels
{
    [CmdletBinding()]
    param(
        [parameter(Position=0)]
        [string[]]$EventChannel,

        [ValidateSet('None', 'All', 'Compute', 'Config', 'High-Availability', 'Hypervisor', `
            'StorageVSP', 'VID', 'VMMS', 'VmSwitch', 'Worker', 'SMB', 'FailoverClustering')]
        [string[]]$HyperVChannels="All",

        [Boolean]$SkipAdminEventChannels = $true,

        [System.Management.Automation.Runspaces.PSSession]$PSSession
    )

    #-----------------------------------
    # Setup
    #-----------------------------------
    $eventChannels = Get-EventChannelList -EventChannel $EventChannel -HyperVChannels $HyperVChannels

    #-------------------------------------------
    # ScriptBlock that disables event channels
    #-------------------------------------------
    $disableEventsScriptBlock = {
        param(
            [string[]] $EventChannels,
            [int64] $MaxSize,
            [boolean] $SkipAdminEventChannels
        )

        foreach ($event in $EventChannels)
        {
            try
            {
                if ((-not $SkipAdminEventChannels) -or ($event -notmatch '.+?-admin$')) {
                    wevtutil set-log $event /enabled:false /quiet
                    if ($LastExitCode -ne 0)
                    {
                        Write-Error "Error: wevtutil failed to disable $event with error $LastExitCode."
                    }
                }
            }
            catch
            {
                continue
            }
        }
    }

    #-------------------------------------------
    # Disable event channels on target machine
    #-------------------------------------------
    if (!$PSSession)
    {
        Invoke-Command -ScriptBlock $disableEventsScriptBlock -ArgumentList $eventChannels, $MaxSize, $SkipAdminEventChannels
    }
    else
    {
        Invoke-Command -Session $PSSession -ScriptBlock $disableEventsScriptBlock -ArgumentList $eventChannels, $MaxSize, $SkipAdminEventChannels
    }
}

<#
.SYNOPSIS
    Saves a PowerTest_SavedEventChannels.<Format>.evtx file containing events from the specified time range and event channels.

.DESCRIPTION
    Saves a PowerTest_SavedEventChannels.<Format>.evtx file containing events from the specified time range and event channels.

.PARAMETER StartTime
    Supplies the start time. Defaults to [System.DateTime]::MinValue

.PARAMETER EndTime
    Supplies the end time. Defaults to now.

.PARAMETER LastXMinutes
    Supplies the last X minutes from where the StartTime will be decided.

.PARAMETER EventChannel
    Supplies the event channels that will be saved.

.PARAMETER LogLevel
    Supplies the log level to filter the events to be saved.
    Valid values: 'All', 'Critical', 'Warning', 'Verbose', 'Error', 'Information'.
    Defaults to All.

.PARAMETER HyperVChannels
    Array with friendly names for common Hyper-V Channels. Defaults to None.

.PARAMETER PSSession
    Supplies an optional PSSession to run the cmdlet on. This is useful if you need to collect
    events logged on a remote session.

.PARAMETER DestinationPath
    Supplies the path where the .evtx file will be stored. By the default it'll be stored
    in the current working directory.

.PARAMETER DestinationFileName
    Supplies the file name to use when saving the events. The final file name will be
    "DestinationFileName.evtx"".

.EXAMPLE
    Save-EventChannels -LogLevel Error, Critical -IncludeHyperVChannels -HyperVChannels VMMS, Worker

.EXAMPLE
    Save-EventChannels -LastXMinutes 60 -LogLevel Error, Critical -HyperVChannels VMMS, Worker
        Saves VMMS and Worker Critical/Error events into .evtx file from the last 60 minutes.
#>
function Save-EventChannels
{
    [CmdletBinding()]
    param(
        [parameter(Position = 0)]
        [string]$StartTime,

        [parameter(Position = 1)]
        [string]$EndTime,

        [int]$LastXMinutes,

        [string[]]$EventChannel,

        [ValidateSet('All', 'Critical', 'Error', 'Warning', 'Information', 'Verbose')]
        [string[]]$LogLevel="All",

        [ValidateSet('None', 'All', 'Compute', 'Config', 'High-Availability', 'Hypervisor', `
            'StorageVSP', 'VID', 'VMMS', 'VmSwitch', 'Worker', 'SMB', 'FailoverClustering')]
        [string[]]$HyperVChannels="All",

        [System.Management.Automation.Runspaces.PSSession]$PSSession,

        [string]$DestinationPath = (Get-Location),
        [string]$DestinationFileName = "SavedEventChannels"
    )

    #-----------------------------------
    # Setup
    #-----------------------------------
    $eventChannels = @()

    if ($HyperVChannels -notcontains "None")
    {
        if ($HyperVChannels -contains "All")
        {
            foreach ($channel in $HYPERV_EVENT_CHANNELS.Keys)
            {
                $eventChannels += $HYPERV_EVENT_CHANNELS[$channel]
            }
        }
        else
        {
            foreach ($channel in $HyperVChannels)
            {
                $eventChannels += $HYPERV_EVENT_CHANNELS[$channel]
            }
        }
    }

    if ($EventChannel)
    {
        $eventChannels += $EventChannel
    }

    $levels = "("
    if ($LogLevel -contains "All")
    {
        $LogLevel = @('Critical', 'Error', 'Warning', 'Information', 'Verbose')
    }

    foreach ($lvl in $LogLevel)
    {
        switch ($lvl)
        {
            "Critical" { $levels += "Level=1 or " }
            "Error" { $levels += "Level=2 or " }
            "Warning" { $levels += "Level=3 or " }
            "Information" { $levels += "Level=4 or " }
            "Verbose" { $levels += "Level=5 or " }
        }
    }

    # remove last ' or '
    $levels = $levels -replace ".{4}$"
    $levels += ") and "

    # Get time range
    $gmtDiff = [System.DateTime]::UtcNow - [System.DateTime]::Now

    $startDateTime = [System.DateTime]::MinValue
    if ($StartTime -ne "")
    {
        $startDateTime = [System.DateTime]::Parse($StartTime)
    }

    $stopDateTime = [System.DateTime]::Now
    if ($EndTime -ne "")
    {
        $stopDateTime = [System.DateTime]::Parse($EndTime)
    }

    if ($LastXMinutes)
    {
        $startDateTime = $stopDateTime.Subtract([System.TimeSpan]::new(0, $LastXMinutes, 0))
    }

    $startDateTime = $startDateTime.Add($gmtDiff)
    $stopDateTime = $stopDateTime.Add($gmtDiff)

    $startDateTime = $startDateTime.GetDateTimeFormats('o')
    $stopDateTime = $stopDateTime.GetDateTimeFormats('o')

    #-----------------------------------
    # Build query
    #-----------------------------------
    $query = '<QueryList>'
    $query +='<Query Id="0" Path="System">'

    foreach ($provider in $eventChannels)
    {
        $queryPart = '<Select Path="' + $provider +'">*'
        $queryPart += '[System[' + $levels + 'TimeCreated[@SystemTime&gt;="' + $startDateTime + '" and @SystemTime&lt;="' + $stopDateTime + '"]]]'
        $queryPart += '</Select>'

        $query += $queryPart
    }

    $query += '</Query>'
    $query += '</QueryList>'

    #-----------------------------------
    # ScriptBlock that generates evtx file
    #-----------------------------------

    $generateEvtxFileScriptBLock = {
        param(
            [string] $EvtxQuery,
            [string] $DestinationFile
        )

        $xmlQueryFile = $env:TEMP +  "\" + ([Guid]::NewGuid()).Guid + ".xml"
        $EvtxQuery | Out-File -Encoding ascii $xmlQueryFile
        wevtutil export-log /structuredquery $xmlQueryFile $DestinationFile /overwrite:true

        if ($LastExitCode -ne 0)
        {
            throw "Failed to collect events with exit code $LastExitCode."
        }
    }

    #-----------------------------------
    # Run query and generate evtx file
    #-----------------------------------
    try
    {
        $localEvtxFile = Join-Path $DestinationPath "$DestinationFileName.evtx"

        if (!$PSSession)
        {
            # Run it locally
            &$generateEvtxFileScriptBLock $query $localEvtxFile
        }
        else
        {
            # Construct remote destination path
            $sessionEvtxFile = Invoke-Command -Session $PSSession -ScriptBlock {
                $outputEvtxFile = $env:TEMP + "\" + ([Guid]::NewGuid()).Guid + ".evtx"
                return $outputEvtxFile
            }

            # Run it remotely
            Invoke-Command -Session $PSSession -ScriptBlock $generateEvtxFileScriptBlock -ArgumentList $query, $sessionEvtxFile

            # Copy generated evtx to local destination path
            Copy-Item -FromSession $PSSession -Path $sessionEvtxFile -Destination $localEvtxFile -Force
        }
    }
    catch
    {
        Write-Warning $_.ToString()
    }
}