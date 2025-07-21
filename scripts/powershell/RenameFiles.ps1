# Prompt the user for the target directory
$targetDir = Read-Host "Enter the full path of the directory to scan"

# Validate the directory
if (-not (Test-Path -Path $targetDir -PathType Container)) {
    Write-Host "Error: The path '$targetDir' does not exist or is not a directory."
    exit
}

# Prompt the user for the filename prefix to search for
$oldPrefix = Read-Host "Enter the current filename prefix (e.g., 'IMG_')"

# Prompt the user for the new prefix to replace it with
$newPrefix = Read-Host "Enter the new filename prefix (e.g., 'Vacation_')"

# Find matching files
$files = Get-ChildItem -Path $targetDir -File | Where-Object { $_.Name -like "$oldPrefix*" }
$fileCount = $files.Count

# Display the confirmation message in vertical format
Write-Host "`nPlease confirm the following:`n"
Write-Host "Target Directory:`n$targetDir"
Write-Host "Old Prefix:`n$oldPrefix"
Write-Host "New Prefix:`n$newPrefix"
Write-Host "Matching Files Found:`n$fileCount"
$confirmation = Read-Host "`nProceed with renaming? (Y/N)"

if ($confirmation -eq "Y") {
    if ($fileCount -eq 0) {
        Write-Host "No files found starting with '$oldPrefix' in '$targetDir'."
    } else {
        foreach ($file in $files) {
            $newName = $file.Name -replace "^$oldPrefix", $newPrefix
            Rename-Item -Path $file.FullName -NewName $newName
            Write-Host "Renamed '$($file.Name)' to '$newName'"
        }
        Write-Host "Renaming complete."
    }
} else {
    Write-Host "Operation cancelled."
}

