$Global:workingDir = (Resolve-Path .).Path;
. "$($Global:workingDir)\common\read-config.ps1";

try {
    readConfig;

    # Registger Microsoft.DocumentDB provider in the Azure tenant
    try {
        #Register-AzResourceProvider -ProviderNamespace Microsoft.DocumentDB;
    } catch {};
    
    

    # Create Azure Cosmos DB account
    Write-Host "Creating Azure Cosmos DB account..."

    $consistencyPolicy = @{
        defaultConsistencyLevel = "Eventual"
    };

    $dbProperties = @{
        databaseAccountOfferType = "Standard"
        consistencyPolicy = $consistencyPolicy
    };

    $prop = @{
        Name = $config.cosmosDBAccountName
        ResourceGroupName = $config.resourceGroupName
        Location = $config.resourceGroupAzureRegion
        ResourceType = "Microsoft.DocumentDB/databaseAccounts"
        ApiVersion = "2019-08-01"
        Kind = "MongoDB"
        Properties = $dbProperties
    };
    #New-AzResource @prop -ErrorAction Stop;
    Write-Host "Azure Cosmos DB account $($config.cosmosDBAccountName) created in resource group $($config.resourceGroupName)";


    # Create Azure Cosmos DB database
    Write-Host "Creating Azure Cosmos DB database..."

    $dbProperties = @{
        resource = @{ id = $config.cosmosDBDatabaseName }
        options = @{ Throughput = "400" }
    };

    $prop = @{
        Name = "$($config.cosmosDBAccountName)/$($config.cosmosDBDatabaseName)"
        ResourceGroupName = $config.resourceGroupName
        ResourceType = "Microsoft.DocumentDB/databaseAccounts/mongodbDatabases"
        ApiVersion = "2019-08-01"
        Properties = $dbProperties
    };
    Write-Host $prop.Name;
    New-AzResource @prop -ErrorAction Stop;
    Write-Host "Azure Cosmos DB database $($config.cosmosDBDatabaseName) created in resource group $($config.resourceGroupName)";
    


    <#
    $failoverLocations = @(
        @{ "locationName"=$config.resourceGroupAzureRegion; "failoverPriority"=0 }
    )
    
    

    
    $CosmosDBProperties = @{
        "databaseAccountOfferType"="Standard";
        "locations"=$locations;
        "consistencyPolicy"=$consistencyPolicy;
        "enableMultipleWriteLocations"="false"
    }
    
    #>
} catch {
    Write-Error $_;
}
