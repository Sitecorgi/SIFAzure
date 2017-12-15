Function Invoke-SetSitecoreParams {
    
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

    process{
        if(-not $global:SitecoreXPAzureParams)
        {
            $global:SitecoreXPAzureParams = @{}
        }
    
        $global:SitecoreXPAzureParams['sitecoreAdminPassword'] = $SitecoreAdminPassword
        $global:SitecoreXPAzureParams['sqlServerLogin'] = $SqlUsername
        $global:SitecoreXPAzureParams['sqlServerPassword'] = $SqlPassword
        $global:SitecoreXPAzureParams['xcSingleMsDeployPackageUrl'] = $XcSingleMsDeployPackageUrl
        $global:SitecoreXPAzureParams['singleMsDeployPackageUrl'] = $SingleMsDeployPackageUrl
        Write-Host "Sitecore Parameters Set"
        $global:SitecoreXPAzureParams
    }
}

Register-SitecoreInstallExtension -Command Invoke-SetSitecoreParams -As SetSitecoreParams -Type Task