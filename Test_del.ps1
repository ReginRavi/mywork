Import-Module "C:\Users\raviregi\OneDrive - Unisys\UL\SCCM Client Center 2 NEW\smsclictr.automation.DLL"
$inifile=Get-Content "C:\Users\raviregi\OneDrive - Unisys\Desktop\others\.ini\Test.ini"
$comp="."
$SCCMClient = New-Object -TypeName smsclictr.automation.SMSClient($comp)

Function HWInv_Full($comp){
    $SCCMClient.schedules.HardwareInventory($true) 
    START-SLEEP -S 6
}  
Function SWInv_Full($comp){
    $SCCMClient.schedules.SoftwareInventory($TRUE)
    START-SLEEP -S 6
}
Function DDR($comp){
        $SCCMClient.schedules.DataDiscovery()         
        START-SLEEP -S 6
}
Function UserPolicy($comp){
        $SCCMClient.schedules.UserPolicyReq() | out-null
        $SCCMClient.schedules.UserPolicyEval() | Out-Null
}
Function RepairClient($comp){
    $SCCMClient.RepairClient()
}
Function RepairClient($comp){
    $SCCMClient.ResetPolicy()
}

    $inifile|foreach-object -begin {$h=@{}} -process {$k = [regex]::split($_,'='); 
    
      if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

    if ($h.Item("HardwareInventoryFull") -eq "yes") {

        HWInv_Full($comp)
        
        WRITE-HOST "Initiated H/W Inventory"
    }
    if ($h.Item("SoftwareInventoryFull") -eq "yes") {

        SWInv_Full($comp)
        WRITE-HOST "Initiated S/W Inventory"
    }
    if ($h.Item("UserPolicy") -eq "yes") {

        UserPolicy($comp)
        WRITE-HOST "Initiated user policy"
    }
    if ($h.Item("DDR") -eq "yes") {

        DDR($comp)
        WRITE-HOST "Initiated Discovery Data Record"
    }
    if ($h.Item("CCMRepair") -eq "yes") {

        RepairClient($comp)
        WRITE-HOST "Initiated CCMRepair"
    }
    

    