# ======================================
# Convert JPG/PNG to WebP (Adaptive Sequential/Parallel + Progress)
# ======================================

Add-Type -AssemblyName System.Windows.Forms

# ---- Settings ----
$jpgQuality  = 80
$pngQuality  = 85
$dryRun      = $false      # set to $true for testing
$throttle    = 4           # number of parallel jobs; set 1 for sequential
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
Write-Host "Throttle:      $throttle"
Write-Host "Dry run:       $dryRun"
Write-Host "Originals:     Recycle Bin"
Write-Host ""

$confirm = Read-Host "Proceed? (y/n)"
if ($confirm -ne 'y') { Write-Host "Cancelled."; return }

# ---- Collect files ----
$files = Get-ChildItem $root -Recurse -Include *.jpg,*.jpeg,*.png -File
$totalFiles = $files.Count

if ($totalFiles -eq 0) { Write-Host "No images found."; return }

Add-Content $logFile "`n=== Run started $(Get-Date) ==="

# ---- Adaptive conversion ----
$results = @()

if ($throttle -eq 1) {
    # --- Sequential loop ---
    $index = 0
    foreach ($file in $files) {
        $index++
        Write-Progress -Activity "Converting images to WebP" `
                       -Status "${index} of ${totalFiles}: $($file.Name)" `
                       -PercentComplete (($index / $totalFiles) * 100)

        $src  = $file.FullName
        $dest = Join-Path $file.DirectoryName ($file.BaseName + ".webp")
        $quality = if ($file.Extension -match "png") { $pngQuality } else { $jpgQuality }
        $before = $file.Length

        if (Test-Path $dest) { continue }

        if ($dryRun) {
            $results += [pscustomobject]@{ File=$src; Before=$before; After=0; Saved=0; Status="DRY RUN" }
            continue
        }

        magick "$src" -strip -quality $quality "$dest"
        if (Test-Path $dest) { Remove-ItemSafely "$src" -Confirm:$false }

        $after = if (Test-Path $dest) { (Get-Item $dest).Length } else { 0 }
        $results += [pscustomobject]@{ File=$src; Before=$before; After=$after; Saved=($before-$after); Status="OK" }
    }
    Write-Progress -Activity "Converting images to WebP" -Completed

} else {
    # --- Parallel loop ---
    $progressCounter = [System.Collections.Concurrent.ConcurrentBag[int]]::new()

    $results = $files | ForEach-Object -Parallel {
        $src  = $_.FullName
        $dest = Join-Path $_.DirectoryName ($_.BaseName + ".webp")
        $quality = if ($_.Extension -match "png") { $using:pngQuality } else { $using:jpgQuality }
        $before = $_.Length

        if (Test-Path $dest) { 
            $counter = $using:progressCounter
            $counter.Add(1);
            return $null
        }

        if ($using:dryRun) { 
            $counter = $using:progressCounter
            $counter.Add(1);
            return [pscustomobject]@{ File=$src; Before=$before; After=0; Saved=0; Status="DRY RUN" } 
        }

        magick "$src" -strip -quality $quality "$dest"
        if (Test-Path $dest) { Remove-ItemSafely "$src" -Confirm:$false }

        $after = if (Test-Path $dest) { 
            $counter = $using:progressCounter
            (Get-Item $dest).Length } else { 0 }
            $counter.Add(1)

        return [pscustomobject]@{ File=$src; Before=$before; After=$after; Saved=($before-$after); Status="OK" }
    } -ThrottleLimit $throttle

    # Main thread progress display
    while ($progressCounter.Count -lt $totalFiles) {
        $percent = ($progressCounter.Count / $totalFiles) * 100
        Write-Progress -Activity "Converting images to WebP" `
                       -Status "$($progressCounter.Count) of $totalFiles processed" `
                       -PercentComplete $percent
        Start-Sleep -Milliseconds 200
    }
    Write-Progress -Activity "Converting images to WebP" -Completed
}

# ---- Logging ----
foreach ($r in $results | Where-Object { $_ -ne $null }) {
    Add-Content $logFile ("{0} | {1:N1} KB → {2:N1} KB | Saved {3:N1} KB" -f `
        $r.Status, ($r.Before / 1KB), ($r.After / 1KB), ($r.Saved / 1KB))
}

# ---- Summary ----
$totalBefore = ($results | Measure-Object Before -Sum).Sum
$totalAfter  = ($results | Measure-Object After -Sum).Sum
$totalSaved  = $totalBefore - $totalAfter
$percent     = if ($totalBefore -gt 0) { [math]::Round(($totalSaved / $totalBefore) * 100, 1) } else { 0 }

Add-Content $logFile "=== Run finished $(Get-Date) ==="

Write-Host ""
Write-Host "================ SUMMARY ================"
Write-Host ("Files converted : {0}" -f ($results | Where-Object { $_ -ne $null }).Count)
Write-Host ("Before size     : {0:N1} MB" -f ($totalBefore / 1MB))
Write-Host ("After size      : {0:N1} MB" -f ($totalAfter / 1MB))
Write-Host ("Space saved     : {0:N1} MB ({1}%)" -f ($totalSaved / 1MB), $percent)
Write-Host "Log file: $logFile"
Write-Host "========================================="

