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
        [parameter(Mandatory=$false)]
        [Boolean]$DebugMode
        )

        process{
        Import-Module AzureRM.Resources
        Invoke-SetResourceGroup -ResourceGroupName $ResourceGroupName -Location $Location
        Write-Information "Beginning Deployment of ARM template, this may take some time"
    
        if($DebugMode){
            New-AzureRmResourceGroupDeployment -Name $DeploymentName `
            -ResourceGroupName $ResourceGroupName `
            -TemplateUri $TemplateUri `
            -TemplateParameterObject $global:SitecoreXPAzureParams `
            -Debug `
            -DeploymentDebugLogLevel All `
        }
        else{
            New-AzureRmResourceGroupDeployment -Name $DeploymentName `
            -ResourceGroupName $ResourceGroupName `
            -TemplateUri $TemplateUri `
            -TemplateParameterObject $global:SitecoreXPAzureParams `
            -DeploymentDebugLogLevel None `
        }
             
        Remove-Variable -Name SitecoreXPAzureParams -Scope Global
        Write-Output "Deployment Complete"
        }  
}

Register-SitecoreInstallExtension -Command Invoke-NewAzureRmResourceGroupDeployment -As NewAzureRmResourceGroupDeployment -Type Task