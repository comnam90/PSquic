# PSquic Module Usage Examples

This document provides examples of how to use the PSquic PowerShell module to interact with the Quic API.

## Prerequisites

1. Import the module:
```powershell
Import-Module ./Source/PSquic.psd1
```

2. Get your API key from your Quic portal

## Basic Usage

### Connect to the API

```powershell
# Connect with your API key
Connect-PSquic -ApiKey "your-api-key-here"
```

### Disconnect from the API

```powershell
# Clear the stored API key
Disconnect-PSquic
```

### Get Available Services
```powershell
# List all services you have access to
$services = Get-PSquicServices
Write-Host "Available services: $($services -join ', ')"
```

### Get Session Information
```powershell
# Get session info for a specific service
$session = Get-PSquicSession -ServiceId $services[0]
Write-Host "Session status: $($session.status)"
Write-Host "Session type: $($session.sessionType)"
Write-Host "Active IPv4: $($session.activeIPv4Prefix)"
```

### Get Session Info for All Services (Pipeline)
```powershell
# Use pipeline to get session info for all your services
$allSessions = Get-PSquicServices | Get-PSquicSession
$allSessions | ForEach-Object {
    Write-Host "Service: $($_.service.entityUniqueId) - Status: $($_.status)"
}
```

### Download Weather Map
```powershell
# Download weather map to memory
$weatherData = Get-PSquicWeatherMap
Write-Host "Downloaded $($weatherData.Length) bytes of weather map data"

# Download weather map to file
$weatherFile = Get-PSquicWeatherMap -OutFile "~/Downloads/weather.jpg"
Write-Host "Weather map saved to: $($weatherFile.FullName)"
```

## Complete Example
```powershell
# Import the module
Import-Module ./Source/PSquic.psd1

# Connect to API
Connect-PSquic -ApiKey "your-api-key-here"

# Get and display all service session information
Write-Host "=== Quic Service Status ===" -ForegroundColor Green

Get-PSquicServices | ForEach-Object {
    $serviceId = $_
    try {
        $session = Get-PSquicSession -ServiceId $serviceId
        Write-Host "Service: $serviceId" -ForegroundColor Yellow
        Write-Host "  Status: $($session.status)"
        Write-Host "  Type: $($session.sessionType)"
        Write-Host "  IPv4: $($session.activeIPv4Prefix)"
        Write-Host "  IPv6: $($session.activeIPv6Prefix)"
        Write-Host "  Username: $($session.service.username)"
        Write-Host ""
    }
    catch {
        Write-Warning "Failed to get session for service $serviceId`: $($_.Exception.Message)"
    }
}

# Download weather map
try {
    $weatherFile = Get-PSquicWeatherMap -OutFile "~/quic-weather.jpg"
    Write-Host "Weather map downloaded to: $($weatherFile.FullName)" -ForegroundColor Green
}
catch {
    Write-Warning "Failed to download weather map: $($_.Exception.Message)"
}

# Disconnect when done
Disconnect-PSquic
Write-Host "Disconnected from Quic API" -ForegroundColor Green
```

## Error Handling

The module provides detailed error messages for common scenarios:

- **No API Key**: Make sure to run `Connect-PSquic` first
- **Invalid API Key**: Check your API key is correct and has proper permissions
- **Service Not Found**: Verify the service ID exists and you have access
- **Network Issues**: Check your internet connection

## Available Functions

- `Connect-PSquic` - Authenticate with the Quic API
- `Disconnect-PSquic` - Clear the stored API key and disconnect
- `Get-PSquicServices` - List authorized services
- `Get-PSquicSession` - Get session information for services
- `Get-PSquicWeatherMap` - Download the Quic weather map
