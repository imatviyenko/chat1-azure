$Global:workingDir = (Resolve-Path .).Path;
. "$($Global:workingDir)\common\read-config.ps1";

try {
    readConfig;

    # Create Azure storage account
    Write-Host "Creating Azure storage account..."
    $prop = @{
        Name = $config.storageAccountName
        ResourceGroupName = $config.resourceGroupName
        Location = $config.resourceGroupAzureRegion
        Kind = $config.storageAccountKind
        SkuName = $config.storageAccountSkuName
    };
    New-AzStorageAccount @prop -ErrorAction Stop;
    Write-Host "Azure storage account $($config.storageAccountName) created in resource group $($config.resourceGroupName)";

    # Create Azure Storage context
    Write-Host "Creating Azure storage context for accessing storage account $($config.storageAccountName)...";
    $storageContext = New-AzStorageContext -StorageAccountName $config.storageAccountName -UseConnectedAccount -ErrorAction Stop;

    Write-Host "Enabling static websites support for Azure storage account $($config.storageAccountName)...";
    Enable-AzStorageStaticWebsite -Context $storageContext -IndexDocument "index.html" -ErrorDocument404Path "404.html" -ErrorAction Stop;
} catch {
    Write-Error $_;
}
