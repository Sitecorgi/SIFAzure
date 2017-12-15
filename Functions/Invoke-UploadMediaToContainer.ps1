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

        Write-Host $("Uploading media $($BlobName) at $($PackageLocation) to Container $($ContainerName)")

        Set-AzureRmCurrentStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName
        
        $storage = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
        $ctx = $storage.Context
        
        $blobExists = Get-AzureStorageBlob -Blob $BlobName -Container $ContainerName -ev notPresent -ea 0

        if(-not $blobExists)
        {
            Set-AzureStorageBlobContent -File $PackageLocation `
            -Container $ContainerName `
            -Blob $BlobName `
            -Context $ctx `
            -Force
        }
    }
}

Register-SitecoreInstallExtension -Command Invoke-UploadMediaToContainer -As UploadMediaToContainer -Type Task