[xml]$xmlContent = Get-Content -Path 'Q:\Projects\Analytical\Plexos\repo for Blake\plexos-EIC-zonal-2023\PLEXOS EIC Zonal v23.6 .xml'

# Convert the XML content to JSON
$jsonContent = $xmlContent | ConvertTo-Json

# Save the JSON content to a file
$jsonContent | Out-File -FilePath 'C:\Work\temp\PLEXOS EIC Zonal v23.6 .json'
