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
        [string]$TemplateUri
        )

        process{
        Import-Module AzureRM.Resources
        Invoke-SetResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location
        Write-Host "Beginning Deployment of ARM template, this may take some time"
    
        New-AzureRmResourceGroupDeployment -Name $DeploymentName `
        -ResourceGroupName $ResourceGroupName `
        -TemplateUri $TemplateUri `
        -TemplateParameterObject $global:SitecoreXPAzureParams `
        -Debug `
        -DeploymentDebugLogLevel All `
        
        Write-Host "Deployment Complete"
        }  
}

Register-SitecoreInstallExtension -Command Invoke-NewAzureRmResourceGroupDeployment -As NewAzureRmResourceGroupDeployment -Type Task