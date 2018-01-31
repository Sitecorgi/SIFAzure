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
        Write-Verbose "SSL Certificate blob added to deployment object"

        $global:SitecoreXPAzureParams['authCertificatePassword'] = $CertPass
        Write-Verbose "SSL Certficiate password added to deployment object"

        Write-Output "SSL Certificate Set"
    }
}

Register-SitecoreInstallExtension -Command Invoke-SetSslCert -As SetSslCert -Type Task