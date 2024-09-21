# Run from target directory, will search through active and subdirs
$currentDir = Get-Location
$logFile = Join-Path -Path $currentDir -ChildPath "dbf_to_csv_conversion_log.txt"

$dbfFiles = Get-ChildItem -Path $currentDir -Filter *.dbf -Recurse
$totalDbfFiles = $dbfFiles.Count
$filesToConvert = 0
$messages = @()
$messages += "Number of dbf files found: $totalDbfFiles"

foreach ($file in $dbfFiles) {
    $newFileName = $file.FullName + ".csv"
    
    if (-not (Test-Path -Path $newFileName)) {
        $filesToConvert++
        Copy-Item -Path $file.FullName -Destination $newFileName
        $messages += "Copied: $($file.FullName) to $newFileName"
    }
}

$messages += "Number of dbf files to convert: $filesToConvert"
$messages += "Process completed. All new .dbf files have been copied with .csv extension."

$messages | ForEach-Object {
    Write-Host $_
    Add-Content -Path $logFile -Value $_
}

Write-Host "Log file created at: $logFile"
