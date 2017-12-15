Function Invoke-GetUserConfirmation {
    
    Write-Verbose "Azure Deployment Parameters"
    $global:SitecoreXPAzureParams
    $confirmation = Read-Host "Are you sure you wish to proceed? [y/n]"
    while($confirmation -ne "y")
    {
        if ($confirmation -eq 'n') {exit}
        $confirmation = Read-Host "Ready? [y/n]"
    }
}

Register-SitecoreInstallExtension -Command Invoke-GetUserConfirmation -As GetUserConfirmation -Type Task