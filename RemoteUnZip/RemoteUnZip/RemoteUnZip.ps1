[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation
try {
    #Assert-VstsPath -LiteralPath $cwd -PathType Container
    #Write-Verbose "Setting working directory to '$cwd'."
    #Set-Location $cwd

    $RemoteComputer = Get-VstsInput -Name RemoteComputer -Require
    $UserName = Get-VstsInput -Name UserName -Require
    $Password = Get-VstsInput -Name Password -Require
    $ZipFile = Get-VstsInput -Name ZipFile -Require
    $OutputPath = Get-VstsInput -Name OutputPath -Require
    $cleanOutput = Get-VstsInput -Name CleanOutput 
    $RemoveZip = Get-VstsInput -Name RemoveZip 

    $scriptBlock = { 
    
    	$zip = $args[0]
    	$output = $args[1]
        $clean = $args[2]
    	$remove = $args[3]
    
    	Write-Verbose "Zip file: $zip "
    	Write-Verbose "Output path: $output"
    
    	Add-Type -AssemblyName System.IO.Compression.FileSystem
    	
    function Unzip
    {
     param([string]$zip, [string]$output)
     [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $output)
    };
    	Write-Verbose "Star extract zip file ..."
        
        if(!(Test-Path -Path $output)) {
            New-Item -ItemType directory -Path $output
        }
        else {
           if($clean)
           {
             Remove-Item "$output\*" -Recurse -Force
           }
        }
    
    	Unzip $zip $output
    	Write-Verbose "Extracting is finished."
    
    	if($remove -eq $TRUE)
    	{
          Write-Verbose "Deleting source zip file..."
          Remove-Item $zip -Force -Recurse
          Write-Verbose "Zip file is deleted."
    	}
          Write-Verbose "Operation has been completed successfully."
    }
    
    $credential = New-Object System.Management.Automation.PSCredential($UserName , (ConvertTo-SecureString -String $Password -AsPlainText -Force));
    $session = New-PSSession -ComputerName $RemoteComputer -Credential $credential;
    Invoke-Command -Session $session -ScriptBlock $scriptblock -ArgumentList $ZipFile ,$OutputPath , $cleanOutput ,$RemoveZip 
    Remove-PSSession -Session $session

    


} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
