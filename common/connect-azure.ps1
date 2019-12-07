$Global:workingDir = (Resolve-Path .).Path;
. "$($Global:workingDir)\common\read-config.ps1";


try {
    readConfig;

    if (!$config -or [string]::IsNullOrEmpty($config.tenantId)) {
        Write-Warning "Run create-service-principal.ps1 and create-resource-group.ps1 scripts to create service principal and resource group before running this script";
        exit;
    }
    
    # Connect to Azure tenant with the admin credentials
    Write-Host "Login to Azure tenant with service principal credentials..."
    $passwordFilePath = "$($Global:workingDir)\config\protected\servicePrincipalPassword.enc";
    $servicePrincipalPasswordAsEncryptedString = Get-Content -Path $passwordFilePath -ErrorAction Stop;
    $servicePrincipalPasswordAsSecureString = $servicePrincipalPasswordAsEncryptedString | ConvertTo-SecureString;
    $servicePrincipal = Get-AzADServicePrincipal -DisplayName $config.servicePrincipalName -ErrorAction Stop;
    $servicePrincipalCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $servicePrincipal.ApplicationId, $servicePrincipalPasswordAsSecureString;
    Connect-AzAccount -Credential $servicePrincipalCredentials -Tenant $config.tenantId -ServicePrincipal -ErrorAction Stop;
    Write-Host "Connected to Azure as service principal $($config.servicePrincipalName)";
} catch {
    Write-Error $_;
}

