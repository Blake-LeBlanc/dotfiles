param(
    [string]$url,
    [string]$outputDirectory = (Get-Location)
)

# Create the output directory if it doesn't exist
if (-not (Test-Path -Path $outputDirectory)) {
    New-Item -Path $outputDirectory -ItemType Directory
}
# Download all files with specific extensions from the URL
$response = Invoke-WebRequest -Uri $url
$links = $response.Links | Where-Object { $_.href -match '\.xlsx$|\.zip$' }

foreach ($link in $links) {
    $fileName = [System.IO.Path]::GetFileName($link.href)
    $outputPath = Join-Path -Path $outputDirectory -ChildPath $fileName
    Invoke-WebRequest -Uri ($url + $link.href) -OutFile $outputPath
    Write-Host "Downloaded: $fileName"
}

