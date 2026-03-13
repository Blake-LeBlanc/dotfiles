$onedriveRoot = "$env:USERPROFILE\OneDrive"

$keepLocal = @(
    "Music/1_Soundtracks and Instrumentals",
    "Music/Alt-J",
    "Music/Atoms for Peace",
    "Music/Billy Corgan",
    "Music/Billy Mohler",
    "Music/Radiohead",
    "Music/Red Hot Chili Peppers",
    "Music/The Smashing Pumpkins",
    "Music/The Smile",
    "Music/Thom Yorke",
    "Music/Tool",
    "Music/Zwan",
    "0_book_notes",
    "0_books",
    "0_Notes",
)

# Expand to full paths for comparison
$keepLocalFull = $keepLocal | ForEach-Object { Join-Path $onedriveRoot $_ }

# Show what will be kept
Write-Host "`nFolders marked to keep locally:" -ForegroundColor Cyan
$keepLocalFull | ForEach-Object { Write-Host "  - $_" }

# Validate keepLocal dirs exist
$invalidDirs = $keepLocalFull | Where-Object { -not (Test-Path $_) }

if ($invalidDirs.Count -gt 0) {
    Write-Host "`nThe following keepLocal directories were not found:" -ForegroundColor Red
    $invalidDirs | ForEach-Object { Write-Host "  - $_" }
    $confirm = Read-Host "`nContinue anyway? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Aborting." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "`nAll keepLocal directories validated." -ForegroundColor Green
}

# Reset attributes on everything outside keepLocal
Write-Host "`nResetting attributes on non-kept files..." -ForegroundColor Yellow
$resetCount = 0

Get-ChildItem -Path $onedriveRoot -Recurse -File | ForEach-Object {
    $file = $_.FullName
    $shouldKeep = $keepLocalFull | Where-Object { $file.StartsWith($_) }

    if (-not $shouldKeep) {
        attrib +U -P $file
        $resetCount++
    }
}

Write-Host "Done. $resetCount file(s) had their attributes reset." -ForegroundColor Green

# Prompt for forced eviction
$confirm = Read-Host "`nForce immediate eviction of cloud-eligible files? (y/n)"
if ($confirm -eq 'y') {
    Write-Host "`nForcing eviction..." -ForegroundColor Yellow
    $shell = New-Object -ComObject Shell.Application
    $folder = $shell.Namespace($onedriveRoot)
    $folder.Self.InvokeVerb("freespace")
    Write-Host "Eviction triggered. OneDrive will free up space shortly." -ForegroundColor Green
} else {
    Write-Host "`nSkipped. OneDrive will evict files on its own schedule." -ForegroundColor Gray
}
