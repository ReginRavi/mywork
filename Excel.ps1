$hash=@()
$anotherhash=@()

$filecontents = get-content 'C:\Windows\CCM\Logs\execmgr.log' 

$hash=$filecontents  -match  'Raising client'  

foreach ($has in $hash) {

$anotherhash=$has -split "," | % { $_.trim()}


([regex]::matches($anotherhash[1], '\w*="\w*"$') | %{$_.value})
#([regex]::matches($anotherhash[2], '\w*="\w*"$') | %{$_.value}) 
#[regex]::matches($anotherhash[1],'.+?(?<=\").+?(?=\")').value 
[regex]::matches($anotherhash[2],'.+?(?<=\").+?(?=\")').value 

}

<#$another='ProgramID="Collect Mapped Drives - ADMIN"'
([regex]::matches($another, '?<=\"') | %{$_.value})

[regex]::matches($another,'.+?(?<=\").+?(?=\")').value #>