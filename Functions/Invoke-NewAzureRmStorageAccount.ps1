Function Invoke-NewAzureRmStorageAccount {
    [Cmdletbinding(SupportsShouldProcess=$true)]
    param(
        [parameter(Mandatory=$true)]
        [string]$StorageAccountName,
        [parameter(Mandatory=$true)]
        [string]$StorageAccountLocation,
        [parameter(Mandatory=$true)]
        [string]$ResourceGroupName
    )

    process{

        Write-Host $("Creating Storage Account $($StorageAccountName) in Resource Group $($ResourceGroupName)")
        $storageAccountExists = Get-AzureRmStorageAccount -Name $StorageAccountName -ResourceGroupName $ResourceGroupName -ev notPresent -ea 0

        if(-not $storageAccountExists){
            New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
            -Name $StorageAccountName `
            -Location $StorageAccountLocation `
            -SkuName Standard_LRS `
            -Kind Storage `
            -EnableEncryptionService Blob
            
            Write-Verbose "Sleeping to allow time for Storage Account to finish provisioning"
            Start-Sleep 10
        }       
    } 
}

Register-SitecoreInstallExtension -Command Invoke-NewAzureRmStorageAccount -As NewAzureRmStorageAccount -Type Task 