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
        [string]$RepAuthenticationApiKey
    )
    

    process{
   
        Write-Verbose "Setting Sitecore deployment parameters"
        
        $global:SitecoreXPAzureParams['sitecoreAdminPassword'] = $SitecoreAdminPassword
        $global:SitecoreXPAzureParams['sqlServerLogin'] = $SqlUsername
        $global:SitecoreXPAzureParams['sqlServerPassword'] = $SqlPassword
        $global:SitecoreXPAzureParams['repAuthenticationApiKey'] = $RepAuthenticationApiKey

        Write-Information "Sitecore Parameters Set"
    }
}

Register-SitecoreInstallExtension -Command Invoke-SetSitecoreParams -As SetSitecoreParams -Type Task