function Find-ActivateScript {
    param (
        [string]$directory
    )

    # First, try to find the Activate.ps1 file somewhere in the current directory
    $activateScriptPath = Join-Path -Path $directory -ChildPath "Activate.ps1"
    if (Test-Path $activateScriptPath) {
        Write-Host "Running Activate.ps1 in $directory"
        . $activateScriptPath  # Run the Activate.ps1 script
        return $true
    } else {
        Write-Host "Activate.ps1 file not found in current or child directories."
        Write-Host "Searching for venv-config.txt file..."
        $configFilePath = Join-Path -Path $directory -ChildPath "venv-config.txt"
        if (Test-Path $configFilePath) {
            Write-Host "venv-config.txt file found!"
            Write-Host "Reading file contents..."
            $venvPath = (Get-Content -Path $configFilePath).Trim()
            $activateScriptPath = Join-Path -Path $venvPath -ChildPath "Scripts\Activate.ps1"
            $activateScriptPath = $activateScriptPath.Trim()
            Write-Host "Path set to: $activateScriptPath"
            if (Test-Path $activateScriptPath) {
                Write-Host "Running Activate.ps1 in $venvPath..."
                . $activateScriptPath  # Run the Activate.ps1 script
                return $true
            } else {
              Write-Host "Hmmm... Something went wrong..."
            }
        } else {
            Write-Warning "No _venv_* directory or venv-config.txt file found. Please create a _venv_* directory or a venv-config.txt file with the path to the desired virtual environment."
        }
    }

    # Recursively search for _venv_ directory or venv-config.txt in child directories
    $childDirectories = Get-ChildItem -Path $directory -Directory
    foreach ($childDir in $childDirectories) {
        $found = Find-ActivateScript -directory $childDir.FullName
        if ($found) {
            return $true
        }
    }

    return $false
}

# Start the search from the current directory
$currentDirectory = Get-Location
$foundScripts = @()
$found = Find-ActivateScript -directory $currentDirectory

if ($found) {
    Write-Host "Activate.ps1 script found and executed, you're now good to go!"
} else {
    Write-Host "No Activate.ps1 script found."
}

