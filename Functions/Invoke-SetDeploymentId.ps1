Function Invoke-SetDeploymentId {
    
    [Cmdletbinding(SupportsShouldProcess=$true)]   
    param(
        [parameter(Mandatory=$true)]
        [string]$DeploymentId
    )

    process {
        if(-not $global:SitecoreXPAzureParams)
        {
            $global:SitecoreXPAzureParams = @{}
        }
      
        $global:SitecoreXPAzureParams['deploymentId'] = $DeploymentId
        
        Write-Output "Deployment ID Set"
        $global:SitecoreXPAzureParams
    }  
}

Register-SitecoreInstallExtension -Command Invoke-SetDeploymentId -As SetDeploymentId -Type Task