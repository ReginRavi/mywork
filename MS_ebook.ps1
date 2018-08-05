$url = "https://blogs.msdn.microsoft.com/mssmallbiz/2017/07/11/largest-free-microsoft-ebook-giveaway-im-giving-away-millions-of-free-microsoft-ebooks-again-including-windows-10-office-365-office-2016-power-bi-azure-windows-8-1-office-2013-sharepo/"
$r1= Invoke-WebRequest -Uri $url
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$path =$DesktopPath+"\PDFDownloads"
If(!(test-path $path))
{
    New-Item -ItemType Directory -Force -Path $path
}
$regex = '([a-zA-Z]{3,})://([\w-]+\.)+([\w-]+(/[\w- ./?%&=]*)*?)+[a-z0-9.\-]'
$r1.ParsedHtml.getElementsByTagName('td')  | Where-Object -Property innerText -Match 'PDF'  | select-object -ExpandProperty innerHTML |Out-File $path\innerhtml.txt 

$files=select-string -path $path\innerhtml.txt -Pattern $regex -AllMatches | % { $_.Matches } |% { $_.Value } 
ForEach ($file in $files) {

    $request = Invoke-WebRequest -Uri $file -MaximumRedirection 0 -ErrorAction Ignore
    $FileName = $request.Headers.Location
if ($FileName -match '.pdf'){
    $output =  $FileName.SubString($FileName.LastIndexOf('/') + 1)
    Invoke-WebRequest -Uri $FileName -OutFile $path\$output

}

}

If (Test-Path $path\innerhtml.txt){
	Remove-Item $path\innerhtml.txt
}







