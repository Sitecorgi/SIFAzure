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

            Write-Verbose "Removing Resource Group $ResourceGroupName"

            Remove-AzureRmResourceGroup -Name $ResourceGroupName -Force

            Write-Output "Resource Group $ResourceGroupName Removed"
    }      
}

Register-SitecoreInstallExtension -Command Invoke-RemoveResourceGroup -As RemoveResourceGroup -Type Task