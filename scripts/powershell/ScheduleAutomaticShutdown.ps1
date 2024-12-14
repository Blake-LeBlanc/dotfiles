# Prompt the user to enter the shutdown time in minutes
$shutdownDelayMinutes = Read-Host -Prompt "How long do you want to wait in minutes until shutdown?"

# Ensure the input is a valid number
if (-not [int]::TryParse($shutdownDelayMinutes, [ref]$null)) {
    Write-Host "Invalid input. Please enter a valid number of minutes."
    exit
}

# Calculate the shutdown time
$shutdownTime = (Get-Date).AddMinutes($shutdownDelayMinutes)

# Display a message with the shutdown time
Write-Host "The computer will shut down in $shutdownDelayMinutes minutes at $shutdownTime."

# Schedule the shutdown using shutdown.exe
Start-Process -FilePath "shutdown.exe" -ArgumentList "/s /t $($shutdownDelayMinutes * 60)"

