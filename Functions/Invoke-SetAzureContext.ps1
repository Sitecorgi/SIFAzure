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
        if($UseServicePrincipal){
            Set-AzureRmContext -SubscriptionId $SubscriptionId -TenantId $TenantId
        }
        else{
            Set-AzureRmContext -SubscriptionId $SubscriptionId        
        }
    }  
}

Register-SitecoreInstallExtension -Command Invoke-SetAzureContext -As SetAzureContext -Type Task