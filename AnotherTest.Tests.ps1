$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
$computer="localhost"
Describe $computer {
    It "does something useful" {
        $true | Should Be $true
    }
    It "Should be pingable" { 
     Test-Connection -ComputerName $computer -Count 2 -Quiet | Should Be $True   
    }    
}