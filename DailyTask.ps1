[System.Diagnostics.Process]::start("chrome.exe","https://social.technet.microsoft.com/forums/en-us/home?category=ConfigMgrCB&filter=alltypes&sort=lastpostdesc")
[System.Diagnostics.Process]::start("chrome.exe","https://social.technet.microsoft.com/forums/en-us/home?category=systemcenter2012configurationmanager&filter=alltypes&sort=lastpostdesc")
#[System.Diagnostics.Process]::start("chrome.exe","https://www.yammer.com/unisys.com#/home")
[System.Diagnostics.Process]::start("chrome.exe","https://social.technet.microsoft.com/forums/en-us/home?category=windowsazureplatform%2Csqlserverdataservices&forum=ssdsgetstarted%2Chypervrecovmgr&filter=alltypes&sort=lastpostdesc")
[System.diagnostics.process]::start("chrome.exe","https://twitter.com/search?q=%20%23ConfigMgr%20&src=savs")
[System.Diagnostics.Process]::start("chrome.exe","https://twitter.com/search?q=%20%23powershell&src=savs")
[System.Diagnostics.process]::Start("chrome.exe","https://stackoverflow.com/questions/tagged/powershell")
[System.Diagnostics.Process]::start("chrome.exe","http://www.c-sharpcorner.com/blogs/")
[System.Diagnostics.process]::start("chrome.exe","https://twitter.com/search?q=%20%23windows10&src=typd")
[System.Diagnostics.process]::start("chrome.exe","https://www.experts-exchange.com/members/regin-ravi.html")
[System.Diagnostics.process]::start("chrome.exe","http://www.itninja.com/blog")
http://www.itninja.com/blog
https://pythonprogramming.net/machine-learning-tutorial-python-introduction/
https://www.linkedin.com/pulse/start-azure-machine-learning-studio-get-storage-najuma-mahamuth/?trackingId=u6xdqSRfgc2Hy7fuc0gleQ%3D%3D
Get-WmiObject -Namespace "root\ccm\site_EUA"
https://stackoverflow.com/questions/28950457/is-there-a-way-to-reinstall-an-application-in-sccm-2012
http://www.febooti.com/products/automation-workshop/online-help/events/run-dos-cmd-command/exit-codes/
WMIC /namespace:\\root\ccm path sms_client CALL TriggerSchedule "{00000000-0000-0000-0000-0000000000

    [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest() | select domains
    #https://docs.microsoft.com/en-us/azure/automation/automation-dsc-overview
    http://jayantech.blogspot.in/2016/06/application-deployment-troubleshooting.html
    

#"chrome.exe","https://app.pluralsight.com/library/courses/windows-10-configuring-70-697-plan-implement-microsoft-intune/table-of-contents"
https://www.red-gate.com/simple-talk/dotnet/net-development/using-c-to-create-powershell-cmdlets-the-basics/?utm_content=59866623&utm_medium=social&utm_source=twitter



Get-NetAdapter -Name * -Physical

(New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/mkellerman/Invoke-CommandAs/master/Invoke-CommandAs.psm1") | iex

Invoke-WebRequest "https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/hyperv-tools/HyperVLogs/HyperVLogs.psm1" -OutFile "HyperVLogs.psm1"