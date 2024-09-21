$json_filename = "winget-export.json"
$json = Get-Content -Raw -Path .\$json_filename | ConvertFrom-Json
$date = Get-Date -Format "yyyyMMdd-HHmmss"
$user_name = $env:USERNAME
$machine_id = $env:COMPUTERNAME
$output_file = "${machine_id}_${user_name}_winget-app-details_${date}.txt"

foreach ($app in $json.Sources[0].Packages) {
    $id = $app.PackageIdentifier
    $version = $app.Version
    Write-Host "Getting info for $id version $version..."
    echo "$id version $version" >> $output_file
    winget show --id $id >> $output_file
    echo "########" >> $output_file
}

echo "End of script output." >> $output_file

Write-Host "Script complete."
Write-Host "Results saved to:"
Write-Host "$output_file"
