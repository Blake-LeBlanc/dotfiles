# Load the XML file
[xml]$xmlContent = Get-Content -Path "Q:\\Projects\\Analytical\\Plexos\\repo for Blake\\plexos-EIC-zonal-2023\\PLEXOS EIC Zonal v23.6 .xml"

# Minify the XML
$minifiedXml = $xmlContent.OuterXml

# Save the minified XML to a file
$minifiedXml | Out-File -FilePath "C:\\Work\\temp\\PLEXOS EIC Zonal v23.6 .xml"

