Function Invoke-SetAzureRegion {
    
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$Location
    )

    process {
        if(-not $global:SitecoreXPAzureParams)
        {
            $global:SitecoreXPAzureParams = @{}
        }
    
        $global:SitecoreXPAzureParams['location'] = $Location
        
        Write-Host "Location Set"
        $global:SitecoreXPAzureParams
    }  
}

Register-SitecoreInstallExtension -Command Invoke-SetAzureRegion -As SetAzureRegion -Type Task