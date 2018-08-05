import-module activedirectory

[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = 'AppCode'
$msg   = 'Enter your AppCode:'
$AppName = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
$AppName

[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.initialDirectory = $initialDirectory
$OpenFileDialog.filter = "txt (*.txt)| *.txt"
$OpenFileDialog.ShowDialog() | Out-Null
$userdata=$OpenFileDialog.filename

$folderpath=$userdata | split-path -parent

$userlist1=get-content $userdata
$UserFolderName=$env:UserName
$Currentime=(get-date).tostring("yyyyMMddHHmmss")
$currentpath=$folderpath
$domainname=(Get-WmiObject Win32_ComputerSystem).Domain
$domainname
$Folpath = $currentpath+"\"+$UserFolderName
$currentfolder=$Folpath
$OUSplit=""
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


#Get-ADGroup $OU1 -Properties Member | Select-Object -ExpandProperty Member  | Get-ADUser | Select-object SamAccountName| out-file $outfile1
#Get-ADGroup $OU2 -Properties Member | Select-Object -ExpandProperty Member  | Get-ADUser | Select-object SamAccountName| out-file $outfile2

}
Export_OUMembers

Function Add_OU {

param()

$VerbosePreference = "Continue"

foreach ($user in $userlist1) {

try{

$splitchar= get-aduser $user  | select DistinguishedName
$OUSplit=($splitchar -split ',*..=')[-5]
$OUSplit
IF ($OUSplit -eq "HLL") {
$OUSplit="HUL"
write-host ="HUL man "
}
"$OUSplit with $user"
$OU="$OUSplit-APP-$AppName-MAN"


Add-ADGroupMember $OU $user -Verbose
"$user  added to $OU" | out-file "$currentfolder\outfile.txt" -append

}

Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
 {

    "$user" | out-file "$currentfolder\userdoesntexists.txt" -append

}

Catch {
"$user Error: $($_.Exception)" | out-file "$currentfolder\exceptions.txt" -append


    }

}

}

add_ou