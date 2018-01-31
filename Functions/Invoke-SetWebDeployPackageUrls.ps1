Function Invoke-SetWebDeployPackageUrls {
    
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$false)]
        [string]$SingleMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$XcSingleMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$cmMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$cdMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$prcMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$repMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$xcRefDataMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$xcCollectMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$xcSearchMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$maOpsMsDeployPackageUrl,
        [parameter(Mandatory=$false)]
        [string]$maRepMsDeployPackageUrl
    )

    process{
        if(-not $global:SitecoreXPAzureParams)
        {
            $global:SitecoreXPAzureParams = @{}
        }
    
        Write-Verbose "Setting Sitecore deployment parameters"
        
        if($XcSingleMsDeployPackageUrl){
            $global:SitecoreXPAzureParams['xcSingleMsDeployPackageUrl'] = $XcSingleMsDeployPackageUrl
            $global:SitecoreXPAzureParams['singleMsDeployPackageUrl'] = $SingleMsDeployPackageUrl
        }
        else{
            $global:SitecoreXPAzureParams['cmMsDeployPackageUrl'] = $cmMsDeployPackageUrl
            $global:SitecoreXPAzureParams['cdMsDeployPackageUrl'] = $cdMsDeployPackageUrl
            $global:SitecoreXPAzureParams['prcMsDeployPackageUrl'] = $prcMsDeployPackageUrl
            $global:SitecoreXPAzureParams['repMsDeployPackageUrl'] = $repMsDeployPackageUrl
            $global:SitecoreXPAzureParams['xcRefDataMsDeployPackageUrl'] = $xcRefDataMsDeployPackageUrl
            $global:SitecoreXPAzureParams['xcCollectMsDeployPackageUrl'] = $xcCollectMsDeployPackageUrl
            $global:SitecoreXPAzureParams['xcSearchMsDeployPackageUrl'] = $xcSearchMsDeployPackageUrl
            $global:SitecoreXPAzureParams['maOpsMsDeployPackageUrl'] = $maOpsMsDeployPackageUrl
            $global:SitecoreXPAzureParams['maRepMsDeployPackageUrl'] = $maRepMsDeployPackageUrl    
        }
               
        Write-Information "Sitecore Web Deploy Packages Set"
        $global:SitecoreXPAzureParams
    }
}

Register-SitecoreInstallExtension -Command Invoke-SetWebDeployPackageUrls -As SetWebDeployPackageUrls -Type Task