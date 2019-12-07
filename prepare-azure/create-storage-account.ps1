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
} catch {
    Write-Error $_;
}
