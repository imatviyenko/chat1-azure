function readConfig() {
    if (!$Global:config) {
        $Global:config = Get-Content -Path "$($Global:workingDir)\config\config.json" -Raw | ConvertFrom-Json;
    }
}

