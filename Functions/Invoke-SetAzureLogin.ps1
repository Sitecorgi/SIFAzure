Function Invoke-SetAzureLogin{
    
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [boolean]$UseServicePrincipal,
        [parameter(Mandatory=$false)]
        [string]$TenantId,
        [parameter(Mandatory=$false)]
        [string]$ApplicationId,
        [parameter(Mandatory=$false)]
        [string]$ApplicationPassword
    )

    process {
        Import-Module AzureRM.Resources
        
        if($UseServicePrincipal){
            $securePassword = ConvertTo-SecureString $ApplicationPassword -AsPlainText -Force
            $credentials = New-Object System.Management.Automation.PSCredential ($ApplicationId, $securePassword)

            Write-Verbose "Logging in with Service Principal"
            Login-AzureRmAccount -ServicePrincipal -Tenant $TenantId -Credential $credentials
        }
        else{
            Login-AzureRmAccount        
        }
    }  
}

Register-SitecoreInstallExtension -Command Invoke-SetAzureLogin -As SetAzureLogin -Type Task