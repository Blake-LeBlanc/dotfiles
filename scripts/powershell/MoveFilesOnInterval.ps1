$sourceDirectory = "Q:\Analytical\Abbyy\0-files-to-import"
$destinationDirectory = "Q:\Analytical\Abbyy\Import"
$timerIntervalSeconds = 15

while ($true) {
    $files = Get-ChildItem -Path $sourceDirectory

    foreach ($file in $files) {
        Move-Item -Path $file.FullName -Destination $destinationDirectory -Force
    }

    Start-Sleep -Seconds $timerIntervalSeconds
}

