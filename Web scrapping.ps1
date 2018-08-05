$AppData=$env:appdata 
$SigPath = '\Microsoft\Signatures' 
$LocalSignaturePath = $AppData+$SigPath 
if (!(Test-path "$LocalSignaturePath\signaturecustom.txt")){
@"
First and Last Name
Title | Group
CompanyName| Direct phone | Mobile phone | firstname.lastname@company.com  
"@ | out-file "$LocalSignaturePath\signaturecustom.txt"

}
$url = "http://www.eduro.com/"
$r1= Invoke-WebRequest -Uri $url
$r4=@{}
$r2=($r1.ParsedHtml.getElementsByTagName('p') )[0]
$r4[1]=$r2.innerText
$r3=($r1.ParsedHtml.getElementsByTagName('p') )[1]
$r4[0]=$r3.innerText
$r4.Values 
$input= Get-content  "$LocalSignaturePath\signaturecustom.txt"
$stream = [System.IO.StreamWriter] "$LocalSignaturePath\Signaturecustom.htm"
$stream.WriteLine("<!DOCTYPE HTML PUBLIC `"-//W3C//DTD HTML 4.0 Transitional//EN`">")
$stream.WriteLine("<HTML><HEAD><TITLE>Signature</TITLE>")
$stream.WriteLine("<META http-equiv=Content-Type content=`"text/html; charset=windows-1252`">")
$stream.WriteLine("<BODY>")
$stream.WriteLine("<SPAN style=`"FONT-SIZE: 10pt; COLOR: black; FONT-FAMILY: `'Trebuchet MS`'`">")
$stream.WriteLine("<BR><BR>")
$stream.WriteLine("<B><SPAN style=`"FONT-SIZE: 9pt; COLOR: gray; FONT-FAMILY: `'Trebuchet MS`'`">" + ($input[0].ToUpper()).Substring(0,$input[0].Length) + "</SPAN></B>")
$stream.WriteLine("<SPAN style=`"FONT-SIZE: 9pt; COLOR: gray; FONT-FAMILY: `'Trebuchet MS`'`">")
$stream.WriteLine("<BR><BR>")
$input=(Get-content  "C:\Users\raviregi\Desktop\Test.txt" )| Select-Object -Skip 1
foreach( $value in  $input) {
$stream.WriteLine("<SPAN style=`"FONT-SIZE: 9pt; COLOR: gray; FONT-FAMILY: `'Trebuchet MS`'`">" + $value +"</SPAN>")
$stream.WriteLine("<BR><BR>")
}
$stream.WriteLine("<SPAN style=`"FONT-SIZE: 7pt; FONT-STYLE: 'italic';COLOR: gray; FONT-FAMILY: `'Trebuchet MS`'`">" + $r4.Values +"</SPAN>")
$stream.WriteLine("<BR>")
$stream.WriteLine("</BODY>")
$stream.WriteLine("</HTML>")
$stream.close()