Function Invoke-UploadMediaToContainer {
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$StorageAccountName,
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [parameter(Mandatory=$true)]
        [string]$ContainerName,
        [parameter(Mandatory=$true)]
        [string]$PackageLocation,
        [parameter(Mandatory=$true)]
        [string]$BlobName
    )

    process{
        Set-AzureRmCurrentStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName
        
        $storage = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
        $ctx = $storage.Context

        Set-AzureStorageBlobContent -File $PackageLocation `
        -Container $containerName `
        -Blob $BlobName `
        -Context $ctx 
    }
}

Register-SitecoreInstallExtension -Command Invoke-NewAzureRmContainer -As NewAzureRmContainer -Type Task