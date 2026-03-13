$onedriveRoot = "$env:USERPROFILE\OneDrive"

$keepLocal = @(
    "Music/1_Soundtracks and Instrumentals"
    ,"Music/Alt-J"
    ,"Music/Atoms for Peace"
    ,"Music/Billy Corgan"
    ,"Music/Billy Mohler"
    ,"Music/Radiohead"
    ,"Music/Red Hot Chili Peppers"
    ,"Music/The Smashing Pumpkins"
    ,"Music/The Smile"
    ,"Music/Thom Yorke"
    ,"Music/Tool"
    ,"Music/Zwan"
    ,"0_book_notes"
    ,"0_books"
    ,"0_Notes"
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

# Calculate space estimate
Write-Host "`nCalculating space usage..." -ForegroundColor Yellow

$toEvict = Get-ChildItem -Path $onedriveRoot -Recurse -File |
    Where-Object { 
        $_.Attributes -notmatch "Offline" -and
        -not ($keepLocalFull | Where-Object { $_.FullName.StartsWith($_) })
    }

$totalSize = ($toEvict | Measure-Object -Property Length -Sum).Sum
$totalSizeGB = [math]::Round($totalSize / 1GB, 2)
$totalSizeMB = [math]::Round($totalSize / 1MB, 2)

$displaySize = if ($totalSizeGB -ge 1) { "$totalSizeGB GB" } else { "$totalSizeMB MB" }

Write-Host "`nSpace savings estimate:" -ForegroundColor Cyan
Write-Host "  Files to be evicted : $($toEvict.Count)"
Write-Host "  Estimated space freed: $displaySize"
Write-Host "`n  (Files in keepLocal folders will remain local and are excluded from this estimate)"

$confirm = Read-Host "`nProceed with attribute reset? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Aborting." -ForegroundColor Red
    exit
}

# Reset attributes on everything outside keepLocal
Write-Host "`nResetting attributes on non-kept files..." -ForegroundColor Yellow
$resetCount = 0

Get-ChildItem -Path $onedriveRoot -Recurse -File | ForEach-Object {
    $file = $_.FullName
    $shouldKeep = $keepLocalFull | Where-Object { $file.StartsWith($_) }

    if (-not $shouldKeep) {
        attrib "+U" "-P" $file
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
