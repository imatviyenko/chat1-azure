function saveConfig() {
    if ($Global:config) {
        $Global:config | ConvertTo-Json | Set-Content -Path "$($Global:workingDir)\config\config.json";
    }
}

