import-module activedirectory

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = 'AppCode'
$msg   = 'Enter your AppCode:'
$AppName = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
$AppName

$AppNamelist=Get-Content ""

foreach($Appname in $AppNamelist){

    Export_OUMembers


}

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

Function Export_OUMembers{

$OU1="$OUSPLIT1-APP-$AppName-MAN"
$OU2="$OUSPLIT2-APP-$AppName-MAN"
$outfile1="$Folpath" + "\"+ "$OU1" + "$Currentime.txt"
$outfile2="$Folpath" + "\"+ "$OU2" + "$Currentime.txt"
$adgroup1=Get-ADGroup $OU1 -Properties Member
$adg1=$adgroup1.DistinguishedName 
$adgroup2=Get-ADGroup $OU2 -Properties Member
$adg2=$adgroup2.DistinguishedName

$group1 =[adsi]"LDAP://$adg1"
$members1 = $group1.psbase.invoke("Members") | foreach {$_.GetType().InvokeMember("name",'GetProperty',$null,$_,$null)} 
$totalcount1=$members1.count
"Total Members in $OU1 is $totalcount1" | out-file $outfile1 -Append
$members1 | out-file $outfile1 -Append

$group2 =[adsi]"LDAP://$adg2"
$members2 = $group2.psbase.invoke("Members") | foreach {$_.GetType().InvokeMember("name",'GetProperty',$null,$_,$null)} 
$totalCount2=$members2.count
"Total Members in $OU1 is $totalCount2" | out-file $outfile2 -Append
$members2 | out-file $outfile2 -Append

}
Export_OUMembers