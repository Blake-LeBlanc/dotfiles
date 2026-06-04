# ConvertToWebp-v2.ps1
# Requires ImageMagick: https://imagemagick.org/script/download.php#windows
# `scoop install main/imagemagick`

param(
    [switch]$MoveOriginals,
    [switch]$DeleteOriginals
)

# Prompt for source folder
$SourceFolder = Read-Host "Source folder (press Enter for current directory)"
if (-not $SourceFolder) { $SourceFolder = "." }
if (-not (Test-Path $SourceFolder)) {
    Write-Error "Folder '$SourceFolder' not found."
    exit 1
}

# Prompt for quality
$qualityInput = Read-Host "WebP quality 0-100 (press Enter for 80)"
if (-not $qualityInput) {
    $Quality = 80
} elseif ($qualityInput -match '^\d+$' -and [int]$qualityInput -le 100) {
    $Quality = [int]$qualityInput
} else {
    Write-Error "Invalid quality value. Please enter a number between 0 and 100."
    exit 1
}

# Check ImageMagick is installed
if (-not (Get-Command magick -ErrorAction SilentlyContinue)) {
    Write-Error "ImageMagick not found. Install it from https://imagemagick.org"
    exit 1
}

# Resolve output folder relative to source
$OutputFolder = Join-Path $SourceFolder "webp_output"

# Determine what to do with originals
$useRecycleBin = [bool](Get-Command Remove-ItemToRecycleBin -ErrorAction SilentlyContinue)

if (-not $DeleteOriginals -and -not $MoveOriginals) {
    $MoveOriginals = $true
}

# Build archive folder name with today's date
$archiveFolder = Join-Path $SourceFolder ("converted_to_webp_" + (Get-Date -Format "yyyyMMdd"))

# Create output and archive folders if needed
New-Item -ItemType Directory -Force -Path $OutputFolder | Out-Null
if ($MoveOriginals) {
    New-Item -ItemType Directory -Force -Path $archiveFolder | Out-Null
}

$extensions = @(
    "*.jpg"
    , "*.jpeg"
    , "*.png"
    , "*.heic"
    , "*.heif"
    , "*.bmp"
    , "*.tiff"
    , "*.gif"
)

$files = $extensions | ForEach-Object { Get-ChildItem -Path $SourceFolder -Filter $_ } | Sort-Object Name

if ($files.Count -eq 0) {
    Write-Host "No image files found in '$SourceFolder'."
    exit 0
}

Write-Host "`nFound $($files.Count) image(s) to convert at quality $Quality...`n"

$success = 0
$failed = 0

foreach ($file in $files) {
    $outPath = Join-Path $OutputFolder "$($file.BaseName).webp"

    Write-Host -NoNewline "Converting $($file.Name) → $($file.BaseName).webp ... "

    & magick $file.FullName -quality $Quality $outPath

    if ($LASTEXITCODE -eq 0) {
        $originalKB = [math]::Round($file.Length / 1KB, 1)
        $newKB      = [math]::Round((Get-Item $outPath).Length / 1KB, 1)
        $saving     = [math]::Round((1 - $newKB / $originalKB) * 100, 0)
        Write-Host "OK  ($originalKB KB → $newKB KB, ${saving}% smaller)"
        $success++

        if ($DeleteOriginals) {
            if ($useRecycleBin) {
                Remove-ItemToRecycleBin $file.FullName
            } else {
                Move-Item $file.FullName $archiveFolder
                Write-Host "  (Note: Remove-ItemToRecycleBin not found, moved to archive folder instead)"
            }
        } elseif ($MoveOriginals) {
            Move-Item $file.FullName $archiveFolder
        }
    } else {
        Write-Host "FAILED"
        $failed++
    }
}

Write-Host "`nDone! $success converted, $failed failed."
Write-Host "WebP files in: '$OutputFolder'"
if ($MoveOriginals) { Write-Host "Originals archived to: '$archiveFolder'" }
