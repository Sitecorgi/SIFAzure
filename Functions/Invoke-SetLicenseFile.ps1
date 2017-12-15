Function Invoke-SetLicenseFile {
    
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    process {
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
}

Register-SitecoreInstallExtension -Command Invoke-SetLicenseFile -As SetLicenseFile -Type Task