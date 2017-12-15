Function Invoke-SetResourceGroup {
    
    [Cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [parameter(Mandatory=$true)]
        [string]$Location
    )

    process {
        $ResourceGroupExists = Get-AzureRmResourceGroup -Name $ResourceGroupName -ev notPresent -ea 0
        
        if (!$ResourceGroupExists) 
        {
            New-AzureRmResourceGroup -Name $ResourceGroupName -Location $location
        }
        
        Write-Host $("Resource Group Set: $($ResourceGroupName)")
    }
}

Register-SitecoreInstallExtension -Command Invoke-SetResourceGroup -As SetResourceGroup -Type Task