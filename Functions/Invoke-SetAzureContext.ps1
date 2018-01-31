Function Invoke-SetAzureContext {
    
    [Cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$SubscriptionId,
        [parameter(Mandatory=$true)]
        [boolean]$UseServicePrincipal,
        [parameter(Mandatory=$false)]
        [string]$TenantId
    )
    
    process{

        Write-Verbose "Setting Azure Context"
        if($UseServicePrincipal){
            Set-AzureRmContext -SubscriptionId $SubscriptionId -TenantId $TenantId
        }
        else{
            Set-AzureRmContext -SubscriptionId $SubscriptionId        
        }

        Write-Information "Azure Context Set"
    }  
}

Register-SitecoreInstallExtension -Command Invoke-SetAzureContext -As SetAzureContext -Type Task