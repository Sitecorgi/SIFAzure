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
    
        Start-Sleep 20
        
        New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $servicePrincipal.ApplicationId
    }  
}

Register-SitecoreInstallExtension -Command Invoke-NewServicePrincipal -As NewServicePrincipal -Type Task