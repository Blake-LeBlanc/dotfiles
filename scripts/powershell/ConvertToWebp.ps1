# ======================================
# Convert JPG/PNG to WebP (Parallel)
# With size comparison + logging
# ======================================

Add-Type -AssemblyName System.Windows.Forms

# ---- Settings ----
$jpgQuality  = 80
$pngQuality  = 85
$dryRun      = $false      # set to $true for testing, $false to actually run
$throttle    = 6           # number of parallel jobs
$logFile     = Join-Path $PSScriptRoot "webp-conversion.log"

# ---- Folder picker ----
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dialog.Description = "Select the folder containing images to convert to WebP"

if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Host "No folder selected. Exiting."
    return
}

$root = $dialog.SelectedPath

# ---- Confirmation ----
Write-Host ""
Write-Host "Folder:        $root"
Write-Host "JPG quality:   $jpgQuality"
Write-Host "PNG quality:   $pngQuality"
Write-Host "Parallel jobs: $throttle"
Write-Host "Dry run:       $dryRun"
Write-Host "Originals:     Recycle Bin"
Write-Host ""

$confirm = Read-Host "Proceed? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Cancelled."
    return
}

# ---- Collect files ----
$files = Get-ChildItem $root -Recurse -Include *.jpg,*.jpeg,*.png -File

if ($files.Count -eq 0) {
    Write-Host "No images found."
    return
}

Add-Content $logFile "`n=== Run started $(Get-Date) ==="

# ---- Parallel conversion ----
$results = $files | ForEach-Object -Parallel {
    $src  = $_.FullName
    $dest = Join-Path $_.DirectoryName ($_.BaseName + ".webp")

    if (Test-Path $dest) {
        return $null
    }

    $quality = if ($_.Extension -match "png") { $using:pngQuality } else { $using:jpgQuality }
    $before  = $_.Length

    if ($using:dryRun) {
        return [pscustomobject]@{
            File   = $src
            Before = $before
            After  = 0
            Saved  = 0
            Status = "DRY RUN"
        }
    }

    magick "$src" -strip -quality $quality "$dest"

    if (Test-Path $dest) {
        $after = (Get-Item $dest).Length
        Remove-Item "$src" -Recycle

        return [pscustomobject]@{
            File   = $src
            Before = $before
            After  = $after
            Saved  = ($before - $after)
            Status = "OK"
        }
    }
    else {
        return [pscustomobject]@{
            File   = $src
            Before = $before
            After  = 0
            Saved  = 0
            Status = "FAILED"
        }
    }

} -ThrottleLimit $throttle

# ---- Filter nulls ----
$results = $results | Where-Object { $_ -ne $null }

# ---- Logging ----
foreach ($r in $results) {
    Add-Content $logFile ("{0} | {1:N1} KB → {2:N1} KB | Saved {3:N1} KB" -f `
        $r.Status,
        ($r.Before / 1KB),
        ($r.After  / 1KB),
        ($r.Saved / 1KB))
}

# ---- Summary ----
$totalBefore = ($results | Measure-Object Before -Sum).Sum
$totalAfter  = ($results | Measure-Object After  -Sum).Sum
$totalSaved  = $totalBefore - $totalAfter
$percent     = if ($totalBefore -gt 0) {
    [math]::Round(($totalSaved / $totalBefore) * 100, 1)
} else { 0 }

Add-Content $logFile "=== Run finished $(Get-Date) ==="

Write-Host ""
Write-Host "================ SUMMARY ================"
Write-Host ("Files converted : {0}" -f $results.Count)
Write-Host ("Before size     : {0:N1} MB" -f ($totalBefore / 1MB))
Write-Host ("After size      : {0:N1} MB" -f ($totalAfter  / 1MB))
Write-Host ("Space saved     : {0:N1} MB ({1}%)" -f ($totalSaved / 1MB), $percent)
Write-Host "Log file: $logFile"
Write-Host "========================================="

