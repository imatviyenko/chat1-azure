$Global:workingDir = (Resolve-Path .).Path;
. "$($Global:workingDir)\common\read-config.ps1";

try {
    readConfig;

    # Create Azure App Service Plan
    Write-Host "Creating Azure App Service Plan..."
    $prop = @{
        Name = $config.appServicePlanName
        ResourceGroupName = $config.resourceGroupName
        Location = $config.resourceGroupAzureRegion
        Tier = $config.appServicePlanTier
    };
    $appServicePlan = New-AzAppServicePlan @prop -ErrorAction Stop;
    Write-Host "Azure App Service Plan $($config.appServicePlanName) created in resource group $($config.resourceGroupName)";

    # Create Azure Web App
    Write-Host "Creating Azure Web App..."
    $prop = @{
        Name = $config.appServiceWebAppName
        ResourceGroupName = $config.resourceGroupName
        Location = $config.resourceGroupAzureRegion
        AppServicePlan = $appServicePlan.Id
    };
    New-AzWebApp @prop -ErrorAction Stop;
    Write-Host "Azure Web App $($config.appServiceWebAppName) created in resource group $($config.resourceGroupName)";
} catch {
    Write-Error $_;
}
