$json_filename = "winget-export.json"
$json = Get-Content -Raw -Path .\$json_filename | ConvertFrom-Json
$output_directory = "C:/winget-applications/"

if (-not (Test-Path $output_directory)) {
    New-Item -ItemType Directory -Path $output_directory | Out-Null
}

foreach ($app in $json.Sources[0].Packages) {
    $id = $app.PackageIdentifier
    $version = $app.Version
    Write-Host "Downloading files for $id version $version..."
    winget download --id $id --version $version --download-directory "$output_directory"
}

Write-Host "Script complete."
