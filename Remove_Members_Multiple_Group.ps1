
import-module activedirectory

$UserFolderName=$env:UserName
$Currentime=(get-date).tostring("yyyyMMddHHmmss")
$currentpath=[Environment]::GetFolderPath("Desktop")
$domainname=(Get-WmiObject Win32_ComputerSystem).Domain
$domainname
$Folpath = $currentpath+"\"+$UserFolderName

If(!(test-path $Folpath))
{
New-Item -ItemType Directory -Force -Path $Folpath
}

if (($domainname -match "S2") -eq $True)

{
$OUSPLIT1 ="EU"
$OUSPLIT2 ="AM"
}
if (($domainname -match "S1") -eq $True)

{
$OUSPLIT1 ="HUL"
$OUSPLIT2 ="AS"
}
if (($domainname -match "S3") -eq $True)

{
$OUSPLIT1 ="LA"
$OUSPLIT2 ="NA"
}
$OUSPLIT1
$OUSPLIT2

$list = get-content "c:\path\userlist.txt"


Function Remove_OUMembers{

$OU1="$OUSPLIT1-APP-$AppName-MAN"
$OU2="$OUSPLIT2-APP-$AppName-MAN"

$grp = get-ADGroup $OU1
$grpDN = $grp.DistinguishedName

$outfile1="$Folpath" + "\"+ "$OU1" + "$Currentime.txt"
$outfile2="$Folpath" + "\"+ "$OU2" + "$Currentime.txt"

foreach ($item in $list)
{
    remove-ADGroupMember -identity $grpDN -Members $item	
    

}
<#$adgroup1=Get-ADGroup $OU1 -Properties Member
$adg1=$adgroup1.DistinguishedName 
$adgroup2=Get-ADGroup $OU2 -Properties Member
$adg2=$adgroup2.DistinguishedName #>



}
Export_OUMembers