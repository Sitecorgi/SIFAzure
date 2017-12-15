Function Invoke-SetSslCert {
    
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$FilePath,
        [parameter(Mandatory=$true)]
        [string]$CertPass
    )

    process{
        if(-not $global:SitecoreXPAzureParams)
        {
            $global:SitecoreXPAzureParams = @{}
        }

        $CertBlob = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($FilePath))
        
        $global:SitecoreXPAzureParams['authCertificateBlob'] = $CertBlob
        
        $global:SitecoreXPAzureParams['authCertificatePassword'] = $CertPass
    
        Write-Host "SSL Certificate Set"
        $global:SitecoreXPAzureParams
    
    }
}

Register-SitecoreInstallExtension -Command Invoke-SetSslCert -As SetSslCert -Type Task