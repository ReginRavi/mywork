$DesktopPath = [Environment]::GetFolderPath("Desktop")
$Dir = get-childitem $DesktopPath -file 
$officeArray=@(".docx",".doc","docm",".rtf",".xls",".xlm",".xlsx",".xlsm",".ppt",".pptx",".pptm",".ACCDB",".ACCDR")
$PicArray=@(".png",".jpeg",".jpg",".bmp")
$scriptArray=@(".ps1",".vbs")
$installerArray=@(".exe",".msi")
$TextFile=@(".txt",".csv")
$others=@($Dir  | Select-Object Extension)
$RootArray=@($officeArray,$PicArray,$scriptArray,$installerArray,$TextFile,$others)
Function MoveFile ($source,$destination) {
      Move-item -path $Fname -Destination $extInFol
}
Function CheckFolder ($extFolder){
    If(!(test-path $extFolder))
    {
        New-Item -ItemType Directory -Force -Path $extFolder
    }
}

$Dir | foreach-Object{
   
    $extname= $_.extension 
 
    $Dname=$_.DirectoryName
    $Fname=$_.FullName
    $Fname
    $extFolder=$Dname+"\"+$extname
foreach ($eacharray in $RootArray)
{
    if ($eacharray -contains $extname){
      if ($RootArray[0] -contains $extname){ $SubFolder="office"}
        if ($RootArray[1] -contains $extname){ $SubFolder="Pics"}
        if ($RootArray[2] -contains $extname){ $SubFolder="Script"}
        if ($RootArray[3] -contains $extname){ $SubFolder="Installer"}
        if ($RootArray[4] -contains $extname){ $SubFolder="Text"} 
        if ($RootArray[5] -contains $extname){ $SubFolder="others"} 
        $extFolder=$Dname+"\"+$SubFolder
        $extInFol=$extFolder+"\"+$extname
        CheckFolder ($extFolder)
        CheckFolder ($extInFol) 
        MoveFile ($Fname,$extInFol)
    }
    
}
            $SubFolder="others"
            $extFolder=$Dname+"\"+$SubFolder
            $extInFol=$extFolder+"\"+$extname
            CheckFolder ($extFolder)
            CheckFolder ($extInFol) 
            MoveFile ($Fname,$extInFol)
   <# if ($RootArray[0] -contains $extname){
        $SubFolder="office"
        $extFolder=$Dname+"\"+$SubFolder
        $extInFol=$extFolder+"\"+$extname
        CheckFolder ($extFolder)
        CheckFolder ($extInFol) 
        MoveFile ($Fname,$extInFol)
    }
    if ($RootArray[1] -contains $extname){
        $SubFolder="Pics"
        $extFolder=$Dname+"\"+$SubFolder
        $extInFol=$extFolder+"\"+$extname
        CheckFolder ($extFolder)
        CheckFolder ($extInFol)
        MoveFile ($Fname,$extInFol)
    } #>
}


