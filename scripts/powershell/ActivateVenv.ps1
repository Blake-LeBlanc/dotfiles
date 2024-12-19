function Find-ActivateScript {
    param (
        [string]$directory,
        [switch]$IsRecursiveCall = $false  # Parameter to distinguish top-level vs recursive calls
    )

    # Only show these messages for the top-level call
    if (-not $IsRecursiveCall) {
        Write-Host "Searching for virtual environment..."
    }

    # First, try to find the Activate.ps1 file
    $activateScriptPath = Join-Path -Path $directory -ChildPath "Activate.ps1"
    if (Test-Path $activateScriptPath) {
        Write-Host "Running Activate.ps1 in $directory"
        . $activateScriptPath
        return $true
    }

    # Check for venv-config.txt
    $configFilePath = Join-Path -Path $directory -ChildPath "venv-config.txt"
    if (Test-Path $configFilePath) {
        Write-Host "venv-config.txt found in $directory"
        $venvPath = (Get-Content -Path $configFilePath).Trim()
        $activateScriptPath = Join-Path -Path $venvPath -ChildPath "Scripts\Activate.ps1"
        $activateScriptPath = $activateScriptPath.Trim()

        if (Test-Path $activateScriptPath) {
            Write-Host "Running Activate.ps1 in $venvPath..."
            . $activateScriptPath
            return $true
        } else {
            Write-Warning "Invalid path in venv-config.txt: $activateScriptPath does not exist"
            return $false
        }
    }

    # Recursively search child directories (silently)
    $childDirectories = Get-ChildItem -Path $directory -Directory
    foreach ($childDir in $childDirectories) {
        $found = Find-ActivateScript -directory $childDir.FullName -IsRecursiveCall $true
        if ($found) {
            return $true
        }
    }

    # Only show the warning for the top-level call
    if (-not $IsRecursiveCall) {
        Write-Warning "No virtual environment configuration found. Please create a venv-config.txt file with the path to the desired virtual environment."
    }

    return $false
}

# Start the search from the current directory
$currentDirectory = Get-Location
$found = Find-ActivateScript -directory $currentDirectory

if ($found) {
    Write-Host "Virtual environment activated successfully, you're good to go!"
}
