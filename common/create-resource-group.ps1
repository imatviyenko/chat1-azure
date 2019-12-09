$Global:workingDir = (Resolve-Path .).Path;
. "$($Global:workingDir)\common\read-config.ps1";

try {
    readConfig;

    if (!$config -or [string]::IsNullOrEmpty($config.tenantId)) {
        Write-Warning "Run create-service-principal.ps1 to create service principal in Azure tenant and then run this script again";
        exit;
    }
    
    # Connect to Azure tenant with the admin credentials
    Write-Host "Login to Azure tenant with admin credentials to create service principal"
    Connect-AzAccount;

    # Get service principal object
    $servicePrincipal = Get-AzADServicePrincipal -DisplayName $config.servicePrincipalName -ErrorAction Stop;

    # Create a new resource group where all Azure resources for this project will be located
    Write-Host "Creating Azure resource group...";
    New-AzResourceGroup -Name $config.resourceGroupName -Location $config.resourceGroupAzureRegion;
    Write-Host "New Azure resource group $($config.resourceGroupName) created in Azure region $($config.resourceGroupAzureRegion)";


    # Give service principal Owner role permissions to the newly created resource group
    Write-Host "Granting service principal Owner permissions to Azure resource group...";
    New-AzRoleAssignment -ObjectId $servicePrincipal.Id -RoleDefinitionName "Owner"  -ResourceGroupName $config.resourceGroupName;
    Write-Host "Service principal $($config.servicePrincipalName) was granted Owner permissions to Azure resource group $($config.resourceGroupName)";

    # Give service principal Storage Blob Data Owner role permissions to the newly created resource group
    Write-Host "Granting service principal Storage Blob Data Owner permissions to Azure resource group...";
    New-AzRoleAssignment -ObjectId $servicePrincipal.Id -RoleDefinitionName "Storage Blob Data Owner" -ResourceGroupName $config.resourceGroupName;
    Write-Host "Service principal $($config.servicePrincipalName) was granted Storage Blob Data Owner permissions to Azure resource group $($config.resourceGroupName)";
} catch {
    Write-Error $_;
}







