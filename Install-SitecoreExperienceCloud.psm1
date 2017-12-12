Function New-ServicePrincipal{
    param(
        [parameter(Mandatory=$true)]
        [string]$Password,
        [parameter(Mandatory=$true)]
        [string]$ServicePrincipalName
    )
    Write-TaskHeader -TaskName "Azure Service Principal" -TaskType "New"
    Import-Module AzureRM.Resources

    Login-AzureRmAccount
    $secpassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $servicePrincipal = New-AzureRmADServicePrincipal -DisplayName $ServicePrincipalName -Password $secpassword

    Start-Sleep 20
    
    New-AzureRmRoleAssignment -RoleDefinitionName Contributor -ServicePrincipalName $servicePrincipal.ApplicationId
}

Function Invoke-NewAzureRmStorageAccount {
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$StorageAccountName,
        [parameter(Mandatory=$true)]
        [string]$StorageAccountLocation,
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName
    )

    New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
    -Name $StorageAccountName `
    -Location $StorageAccountLocation `
    -SkuName Standard_LRS `
    -Kind Storage `
    -EnableEncryptionService Blob

    Start-Sleep 5
}

Function Invoke-NewAzureRmContainer {
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$StorageAccountName,
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [parameter(Mandatory=$true)]
        [string]$ContainerName
    )

    Set-AzureRmCurrentStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName

    New-AzureStorageContainer -Name $ContainerName -Permission Container -Context $ctx
}

Function New-AzureDeploymentParams {

     $global:SitecoreXPAzureParams = @{}
}

Function Set-AzureLogin{

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

    Import-Module AzureRM.Resources
    
    if($UseServicePrincipal){
        $securePassword = ConvertTo-SecureString $ApplicationPassword -AsPlainText -Force
        $credentials = New-Object System.Management.Automation.PSCredential ($ApplicationId, $secpasswd)
        Login-AzureRmAccount -ServicePrincipal -Tenant $TenantId -Credential $credentials
    }
    else{
        Login-AzureRmAccount        
    }
}

Function Set-AzureContext {

    [Cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$SubscriptionId,
        [parameter(Mandatory=$true)]
        [boolean]$UseServicePrincipal,
        [parameter(Mandatory=$false)]
        [string]$TenantId
    )
   
    if($UseServicePrincipal){
        Set-AzureRmContext -SubscriptionId $SubscriptionId -TenantId $TenantId
    }
    else{
        Set-AzureRmContext -SubscriptionId $SubscriptionId        
    }
}

Function Set-ResourceGroup {

    [Cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [parameter(Mandatory=$true)]
        [string]$Location
    )

    $ResourceGroupExists = Get-AzureRmResourceGroup -Name $ResourceGroupName -ev notPresent -ea 0
	
	if (!$ResourceGroupExists) 
	{
		New-AzureRmResourceGroup -Name $ResourceGroupName -Location $location
    }
    
    Write-Host $("Resource Group Set: $($ResourceGroupName)")
}

Function Remove-ResourceGroup {
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [parameter(Mandatory=$true)]
        [boolean]$Confirm
    )

    $ResourceGroupExists = Get-AzureRmResourceGroup -Name $ResourceGroupName -ev notPresent -ea 0

    if(!$ResourceGroupExists){
        throw $("Resource Group $($ResourceGroupName) Not found")
    }

    if($Confirm){
        Remove-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName -Confirm
    }
    else{
        Remove-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName
    }
}

Function Set-SitecoreParams {

    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$SitecoreAdminPassword,
        [parameter(Mandatory=$true)]
        [string]$SqlUsername,
        [parameter(Mandatory=$true)]
        [string]$SqlPassword,
        [parameter(Mandatory=$true)]
        [string]$SingleMsDeployPackageUrl,
        [parameter(Mandatory=$true)]
        [string]$XcSingleMsDeployPackageUrl
    )

    if(-not $global:SitecoreXPAzureParams)
    {
        $global:SitecoreXPAzureParams = @{}
    }

    $global:SitecoreXPAzureParams.Add('sitecoreAdminPassword', $SitecoreAdminPassword)
    $global:SitecoreXPAzureParams.Add('sqlServerLogin', $SqlUsername)
    $global:SitecoreXPAzureParams.Add('sqlServerPassword', $SqlPassword)
    $global:SitecoreXPAzureParams.Add('xcSingleMsDeployPackageUrl', $XcSingleMsDeployPackageUrl)
    $global:SitecoreXPAzureParams.Add('singleMsDeployPackageUrl', $SingleMsDeployPackageUrl)
    Write-Host "Sitecore Parameters Set"
    $global:SitecoreXPAzureParams
}

Function Set-LicenseFile {

    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$FilePath
    )

    if(-not $global:SitecoreXPAzureParams)
    {
        $global:SitecoreXPAzureParams = @{}
    }

    if(-not $global:SitecoreXPAzureParams.containsKey('licenseXml')){
        $licenseFileBlob = Get-Content -Raw -Encoding UTF8 -Path $FilePath | Out-String
        $global:SitecoreXPAzureParams.Add('licenseXml', $licenseFileBlob) 
    }  
    Write-Host "License File Set"
    $global:SitecoreXPAzureParams
}

Function Set-DeploymentId {

    [Cmdletbinding(SupportsShouldProcess=$true)]   
    param(
        [parameter(Mandatory=$true)]
        [string]$DeploymentId
    )
    if(-not $global:SitecoreXPAzureParams)
    {
        $global:SitecoreXPAzureParams = @{}
    }

    if(-not $global:SitecoreXPAzureParams.containsKey('deploymentId')){
        $global:SitecoreXPAzureParams.Add('deploymentId', $DeploymentId)        
    }
    Write-Host "Deployment ID Set"
    $global:SitecoreXPAzureParams
}

Function Set-AzureRegion {
    
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$Location
    )
    if(-not $global:SitecoreXPAzureParams)
    {
        $global:SitecoreXPAzureParams = @{}
    }

    $global:SitecoreXPAzureParams.Add('location', $Location)
    Write-Host "Location Set"
    $global:SitecoreXPAzureParams
}

Function Set-SslCert {

    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$FilePath,
        [parameter(Mandatory=$true)]
        [string]$CertPass
    )

    if(-not $global:SitecoreXPAzureParams)
    {
        $global:SitecoreXPAzureParams = @{}
    }
    if(-not $global:SitecoreXPAzureParams.containsKey('authCertificateBlob')){
        $CertBlob = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($FilePath))
        $global:SitecoreXPAzureParams.Add('authCertificateBlob', $CertBlob)
    }
    if(-not $global:SitecoreXPAzureParams.containsKey('authCertificateBlob')){
        $global:SitecoreXPAzureParams.Add('authCertificatePassword', $CertPass)        
    }

    Write-Host "SSL Certificate Set"
    $global:SitecoreXPAzureParams
}

Function Get-UserConfirmation {

    Write-Host "Azure Deployment Parameters"
    $global:SitecoreXPAzureParams
    $confirmation = Read-Host "Are you sure you wish to proceed? [y/n]"
    while($confirmation -ne "y")
    {
        if ($confirmation -eq 'n') {exit}
        $confirmation = Read-Host "Ready? [y/n]"
    }
}

Function Invoke-NewAzureRmResourceGroupDeployment {

    [Cmdletbinding(SupportsShouldProcess = $true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [parameter(Mandatory=$true)]
        [string]$Location,
        [parameter(Mandatory=$true)]
        [string]$DeploymentName,
        [parameter(Mandatory=$true)]
        [string]$TemplateUri,
        [parameter(Mandatory=$true)]
        [boolean]$Confirm
    )

    Import-Module AzureRM.Resources
    Set-ResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location
    Write-Host "Beginning Deployment of ARM template, this may take some time"

    if($Confirm){
        New-AzureRmResourceGroupDeployment -Name $DeploymentName `
        -ResourceGroupName $ResourceGroupName `
        -TemplateUri $TemplateUri `
        -TemplateParameterObject $global:SitecoreXPAzureParams `
        -Debug `
        -DeploymentDebugLogLevel All `
        -Verbose `
        -Confirm
    }
    else{
        New-AzureRmResourceGroupDeployment -Name $DeploymentName `
        -ResourceGroupName $ResourceGroupName `
        -TemplateUri $TemplateUri `
        -TemplateParameterObject $global:SitecoreXPAzureParams `
        -Debug `
        -DeploymentDebugLogLevel All `
        -Verbose
    }
  
    Write-Host "Deployment Complete"
}

Register-SitecoreInstallExtension -Command Remove-ResourceGroup -As RemoveResourceGroup -Type Task
Register-SitecoreInstallExtension -Command Invoke-NewAzureRmStorageAccount -As InvokeNewAzureRmStorageAccount -Type Task
Register-SitecoreInstallExtension -Command New-ServicePrincipal -As NewServicePrincipal -Type Task
Register-SitecoreInstallExtension -Command Set-AzureLogin -As SetAzureLogin -Type Task
Register-SitecoreInstallExtension -Command Set-AzureContext -As SetAzureContext -Type Task
Register-SitecoreInstallExtension -Command Set-ResourceGroup -As SetResourceGroup -Type Task
Register-SitecoreInstallExtension -Command Set-LicenseFile -As SetLicenseFile -Type Task
Register-SitecoreInstallExtension -Command Set-SslCert -As SetSslCert -Type Task
Register-SitecoreInstallExtension -Command Set-SitecoreParams -As SetSitecoreParams -Type Task
Register-SitecoreInstallExtension -Command Set-AzureRegion -As SetLocation -Type Task
Register-SitecoreInstallExtension -Command Set-DeploymentId -As SetDeploymentId -Type Task
Register-SitecoreInstallExtension -Command Get-UserConfirmation -As GetUserConfirmation -Type Task
Register-SitecoreInstallExtension -Command Invoke-NewAzureRmResourceGroupDeployment -As InvokeNewAzureRmResourceGroupDeployment -Type Task