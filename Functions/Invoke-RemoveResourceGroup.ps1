Function Invoke-RemoveResourceGroup{
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName
    )

    process {
        $ResourceGroupExists = Get-AzureRmResourceGroup -Name $ResourceGroupName -ev notPresent -ea 0
        
            if(!$ResourceGroupExists){
                throw $("Resource Group $($ResourceGroupName) Not found")
            }

            Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force
    }      
}

Register-SitecoreInstallExtension -Command Invoke-RemoveResourceGroup -As RemoveResourceGroup -Type Task