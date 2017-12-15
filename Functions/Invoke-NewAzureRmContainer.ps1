Function Invoke-NewAzureRmContainer {
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$StorageAccountName,
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [parameter(Mandatory=$true)]
        [string]$ContainerName
    )

    process{
        Write-Host $("Creating Container $($ContainerName) in Storage Account $($StorageAccountName) in Resource Group $($ResourceGroupName)")

        Set-AzureRmCurrentStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName      
        $storage = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
        $ctx = $storage.Context

        $ContainerExists = Get-AzureStorageContainer -Name $ContainerName -Context $ctx -ev notPresent -ea 0

        if(-not $ContainerExists){
            New-AzureStorageContainer -Name $ContainerName -Permission Container -Context $ctx           
            Start-Sleep 20
        }
      
    }
}

Register-SitecoreInstallExtension -Command Invoke-NewAzureRmContainer -As NewAzureRmContainer -Type Task