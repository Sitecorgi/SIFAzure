Function Invoke-NewServicePrincipal{
    param(
        [parameter(Mandatory=$true)]
        [string]$Password,
        [parameter(Mandatory=$true)]
        [string]$ServicePrincipalName
    )

    process{
        Write-TaskHeader -TaskName "Azure Service Principal" -TaskType "New"
        Import-Module AzureRM.Resources
    
        Login-AzureRmAccount
        $secpassword = ConvertTo-SecureString $Password -AsPlainText -Force
        $servicePrincipal = New-AzureRmADServicePrincipal -DisplayName $ServicePrincipalName -Password $secpassword

        Write-Verbose "Sleeping to allow time for Service Principal to finish provisioning"
        
        Start-Sleep 20

        Write-Verbose "Assigning contributor role to service principal"
        
        New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $servicePrincipal.ApplicationId
    }  
}

Register-SitecoreInstallExtension -Command Invoke-NewServicePrincipal -As NewServicePrincipal -Type Task