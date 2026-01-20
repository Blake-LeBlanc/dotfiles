Add-Type -AssemblyName System.Windows.Forms

# ---- Settings ----
$jpgQuality  = 80
$pngQuality  = 85
$dryRun      = $false      # set $true to test without changing files
$throttle    = 4           # 1 = sequential, >1 = parallel
$detailedLog = $false      # set $true to log every file conversion
$logFile     = Join-Path $PSScriptRoot "webp-conversion.log"

# ---- Folder picker ----
$dialog = New-Object System.Windows.Forms.FolderBrowserDialog
$dialog.Description = "Select the folder containing images to convert to WebP"

if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK)
{
    Write-Host "No folder selected. Exiting."
    return
}

$root = $dialog.SelectedPath

# ---- Ask about subdirectories ----
Write-Host ""
$recursiveChoice = Read-Host "Include subdirectories? (y/n)"
$recursive = $recursiveChoice -eq 'y'

# ---- Confirmation ----
Write-Host ""
Write-Host "Folder:        $root"
Write-Host "Recursive:     $recursive"
Write-Host "JPG quality:   $jpgQuality"
Write-Host "PNG quality:   $pngQuality"
Write-Host "Throttle:      $throttle"
Write-Host "Dry run:       $dryRun"
Write-Host "Detailed log:  $detailedLog"
Write-Host "Originals:     Recycle Bin"
Write-Host ""

$confirm = Read-Host "Proceed? (y/n)"
if ($confirm -ne 'y')
{
    Write-Host "Cancelled."
    return
}

# ---- Collect files ----
Write-Host "Debug: Searching in '$root'" -ForegroundColor Yellow
$files = if ($recursive) {
    Get-ChildItem $root -Recurse -Include *.jpg,*.jpeg,*.png -File
} else {
    @(
        Get-ChildItem $root -Filter *.jpg -File
        Get-ChildItem $root -Filter *.jpeg -File
        Get-ChildItem $root -Filter *.png -File
    )
}
Write-Host "Debug: Found $($files.Count) files" -ForegroundColor Yellow
if ($files.Count -gt 0 -and $files.Count -le 5) {
    Write-Host "Debug: First few files:" -ForegroundColor Yellow
    $files | Select-Object -First 5 | ForEach-Object { 
        Write-Host "  - Name: $($_.Name) | BaseName: $($_.BaseName) | Extension: $($_.Extension)" -ForegroundColor Yellow 
    }
}
$totalFiles = $files.Count

if ($totalFiles -eq 0)
{
    Write-Host "No images found."
    return
}

Add-Content $logFile "`n=== Run started $(Get-Date) ==="

# ---- Adaptive conversion ----
$results = @()

if ($throttle -eq 1)
{

    # ---- Sequential loop ----
    $index = 0
    foreach ($file in $files)
    {

        $index++

        # ---- Progress ----
        Write-Progress -Activity "Converting images to WebP" `
            -Status "${index} of ${totalFiles}: $($file.Name)" `
            -PercentComplete (($index / $totalFiles) * 100)

        $src = $file.FullName
        $dest = Join-Path $file.DirectoryName ($file.BaseName + ".webp")
        $quality = if ($file.Extension -match "png")
        { $pngQuality 
        } else
        { $jpgQuality 
        }
        $before = $file.Length

        Write-Host "Debug: Processing $($file.Name) -> $($file.BaseName).webp" -ForegroundColor Cyan

        if (Test-Path $dest)
        {
            Write-Host "Debug: Skipping - WebP already exists: $dest" -ForegroundColor Yellow
            continue
        }

        if ($dryRun)
        {
            $results += [pscustomobject]@{
                File = $src
                Before = $before
                After = 0
                Saved = 0
                Status = "DRY RUN"
            }
            continue
        }

        # ---- Convert ----
        Write-Host "Debug: Converting with quality $quality" -ForegroundColor Green
        magick "$src" -strip -quality $quality "$dest"

        # ---- Recycle original ----
        if (Test-Path $dest)
        {
            Write-Host "Debug: Conversion successful, recycling original" -ForegroundColor Green
            Remove-ItemSafely "$src" -Confirm:$false
        }
        else
        {
            Write-Host "Debug: ERROR - Conversion failed, dest file not created!" -ForegroundColor Red
        }

        $after = if (Test-Path $dest)
        { (Get-Item $dest).Length 
        } else
        { 0 
        }

        $results += [pscustomobject]@{
            File = $src
            Before = $before
            After = $after
            Saved = $before - $after
            Status = "OK"
        }
    }

    Write-Progress -Activity "Converting images to WebP" -Completed

} else
{
    # ---- Parallel loop using ForEach-Object -Parallel directly ----
    
    # Start a background runspace to track progress
    $syncHash = [hashtable]::Synchronized(@{
        Completed = 0
        Total = $totalFiles
    })
    
    $progressRunspace = [runspacefactory]::CreateRunspace()
    $progressRunspace.Open()
    $progressRunspace.SessionStateProxy.SetVariable("syncHash", $syncHash)
    $progressRunspace.SessionStateProxy.SetVariable("root", $root)
    $progressRunspace.SessionStateProxy.SetVariable("recursive", $recursive)
    
    $progressScript = [powershell]::Create().AddScript({
        $startingWebPCount = if ($recursive) {
            (Get-ChildItem $root -Recurse -Filter *.webp -File -ErrorAction SilentlyContinue).Count
        } else {
            (Get-ChildItem $root -Filter *.webp -File -ErrorAction SilentlyContinue).Count
        }
        
        while ($syncHash.Completed -lt $syncHash.Total) {
            $currentCount = if ($recursive) {
                (Get-ChildItem $root -Recurse -Filter *.webp -File -ErrorAction SilentlyContinue).Count
            } else {
                (Get-ChildItem $root -Filter *.webp -File -ErrorAction SilentlyContinue).Count
            }
            $newlyCreated = $currentCount - $startingWebPCount
            $syncHash.Completed = $newlyCreated
            
            $percent = if ($syncHash.Total -gt 0) { 
                [Math]::Min(($newlyCreated / $syncHash.Total) * 100, 100) 
            } else { 0 }
            
            Write-Progress -Activity "Converting images to WebP" `
                -Status "$newlyCreated of $($syncHash.Total) processed" `
                -PercentComplete $percent
            
            Start-Sleep -Milliseconds 200
        }
        Write-Progress -Activity "Converting images to WebP" -Completed
    })
    
    $progressScript.Runspace = $progressRunspace
    $progressHandle = $progressScript.BeginInvoke()
    
    # Process files in parallel
    $results = $files | ForEach-Object -Parallel {
        $src = $_.FullName
        $dest = Join-Path $_.DirectoryName ($_.BaseName + ".webp")
        $quality = if ($_.Extension -match "png") { $using:pngQuality } else { $using:jpgQuality }
        $before = $_.Length

        if (Test-Path $dest) {
            return $null
        }

        if ($using:dryRun) {
            return [pscustomobject]@{
                File = $src
                Before = $before
                After = 0
                Saved = 0
                Status = "DRY RUN"
            }
        }

        # Convert
        & magick "$src" -strip -quality $quality "$dest" 2>$null

        # Recycle original
        if (Test-Path $dest) {
            Remove-ItemSafely "$src" -Confirm:$false
        }

        $after = if (Test-Path $dest) { (Get-Item $dest).Length } else { 0 }

        return [pscustomobject]@{
            File = $src
            Before = $before
            After = $after
            Saved = $before - $after
            Status = "OK"
        }
    } -ThrottleLimit $throttle
    
    # Signal progress tracking to complete
    $syncHash.Completed = $syncHash.Total
    Start-Sleep -Milliseconds 500  # Give progress tracker time to update
    
    # Cleanup progress tracker
    $progressScript.EndInvoke($progressHandle)
    $progressScript.Dispose()
    $progressRunspace.Close()
    $progressRunspace.Dispose()
}

# ---- Logging ----
if ($detailedLog)
{
    foreach ($r in $results | Where-Object { $_ -ne $null })
    {
        Add-Content $logFile ("{0} | {1:N1} KB → {2:N1} KB | Saved {3:N1} KB" -f `
                $r.Status, ($r.Before / 1KB), ($r.After / 1KB), ($r.Saved / 1KB))
    }
}

# ---- Summary ----
$totalBefore = ($results | Measure-Object Before -Sum).Sum
$totalAfter = ($results | Measure-Object After -Sum).Sum
$totalSaved = $totalBefore - $totalAfter
$percent = if ($totalBefore -gt 0)
{ [math]::Round(($totalSaved / $totalBefore) * 100, 1) 
} else
{ 0 
}

Add-Content $logFile "=== Run finished $(Get-Date) ==="
Add-Content $logFile ("Files converted : {0}" -f ($results | Where-Object { $_ -ne $null }).Count)
Add-Content $logFile ("Before size     : {0:N1} MB" -f ($totalBefore / 1MB))
Add-Content $logFile ("After size      : {0:N1} MB" -f ($totalAfter / 1MB))
Add-Content $logFile ("Space saved     : {0:N1} MB ({1}%)" -f ($totalSaved / 1MB), $percent)

Write-Host ""
Write-Host "================ SUMMARY ================"
Write-Host ("Files converted : {0}" -f ($results | Where-Object { $_ -ne $null }).Count)
Write-Host ("Before size     : {0:N1} MB" -f ($totalBefore / 1MB))
Write-Host ("After size      : {0:N1} MB" -f ($totalAfter / 1MB))
Write-Host ("Space saved     : {0:N1} MB ({1}%)" -f ($totalSaved / 1MB), $percent)
Write-Host "Log file: $logFile"
Write-Host "========================================="
