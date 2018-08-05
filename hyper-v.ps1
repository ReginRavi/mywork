
function OnApplicationLoad { 
     
    return $true  
} 
 
function OnApplicationExit { 
     
    $script:ExitCode = 0 
} 
 

function Call-Samay-Digital_clock_pff { 

    [void][reflection.assembly]::Load("mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
    [void][reflection.assembly]::Load("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
    [void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
    [void][reflection.assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
    [void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") 
    [void][reflection.assembly]::Load("System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
    [void][reflection.assembly]::Load("System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") 
    [void][reflection.assembly]::Load("System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089") 
    [void][reflection.assembly]::Load("System.ServiceProcess, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a") 
    
    [System.Windows.Forms.Application]::EnableVisualStyles() 
    $formSamayPowershellDigit = New-Object 'System.Windows.Forms.Form' 
    $Clocklabel = New-Object 'System.Windows.Forms.Label' 
    $timer1 = New-Object 'System.Windows.Forms.Timer' 
    $InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState' 
     
     
   
     
    $formSamayPowershellDigit_Load={ 
        #TODO: Initialize Form Controls here 
         
    } 
     
    $Clocklabel_Click={ 
        #TODO: Place custom script here 
         
    } 
     
    $timer1_Tick={ 
        #TODO: Place custom script here 
        $Clocklabel.text = (Get-Date).ToString("HH:mm:ss") 
    } 
     
   
    $Form_StateCorrection_Load= 
    { 
        #Correct the initial state of the form to prevent the .Net maximized form issue 
        $formSamayPowershellDigit.WindowState = $InitialFormWindowState 
    } 
     
    $Form_Cleanup_FormClosed= 
    { 
        #Remove all event handlers from the controls 
        try 
        { 
            $Clocklabel.remove_Click($Clocklabel_Click) 
            $formSamayPowershellDigit.remove_Load($formSamayPowershellDigit_Load) 
            $timer1.remove_Tick($timer1_Tick) 
            $formSamayPowershellDigit.remove_Load($Form_StateCorrection_Load) 
            $formSamayPowershellDigit.remove_FormClosed($Form_Cleanup_FormClosed) 
        } 
        catch [Exception] 
        { } 
    } 
    
     
    $formSamayPowershellDigit.Controls.Add($Clocklabel) 
    $formSamayPowershellDigit.BackColor = 'LightSkyBlue' 
    $formSamayPowershellDigit.ClientSize = '311, 94' 
    $formSamayPowershellDigit.FormBorderStyle = 'FixedSingle' 
    $formSamayPowershellDigit.MaximizeBox = $False 
    $formSamayPowershellDigit.Name = "formSamayPowershellDigit" 
    $formSamayPowershellDigit.Opacity = 0.8 
    $formSamayPowershellDigit.ShowIcon = $False 
    $formSamayPowershellDigit.SizeGripStyle = 'Hide' 
    $formSamayPowershellDigit.StartPosition = 'CenterScreen' 
    $formSamayPowershellDigit.Text = "Samay : Powershell Digital Clock  " 
    $formSamayPowershellDigit.add_Load($formSamayPowershellDigit_Load) 
    # 
    # Clocklabel 
    # 
    $Clocklabel.Font = "Segoe UI, 36pt" 
    $Clocklabel.ForeColor = 'White' 
    $Clocklabel.Location = '34, 9' 
    $Clocklabel.Name = "Clocklabel" 
    $Clocklabel.Size = '265, 63' 
    $Clocklabel.TabIndex = 0 
    $Clocklabel.Text = "label1" 
    $Clocklabel.add_Click($Clocklabel_Click) 
    # 
    # timer1 
    # 
    $timer1.Enabled = $True 
    $timer1.Interval = 1 
    $timer1.add_Tick($timer1_Tick) 
    #endregion Generated Form Code 
 
    #---------------------------------------------- 
 
    #Save the initial state of the form 
    $InitialFormWindowState = $formSamayPowershellDigit.WindowState 
    #Init the OnLoad event to correct the initial state of the form 
    $formSamayPowershellDigit.add_Load($Form_StateCorrection_Load) 
    #Clean up the control events 
    $formSamayPowershellDigit.add_FormClosed($Form_Cleanup_FormClosed) 
    #Show the Form 
    return $formSamayPowershellDigit.ShowDialog() 
 
} #End Function 
 
#Call OnApplicationLoad to initialize 
if((OnApplicationLoad) -eq $true) 
{ 
    #Call the form 
    Call-Samay-Digital_clock_pff | Out-Null 
    #Perform cleanup 
    OnApplicationExit 
} 