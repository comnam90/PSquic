function Get-PSquicWeatherMap {
    <#
    .SYNOPSIS
        Downloads the latest Quic weather map.
    
    .DESCRIPTION
        This function downloads the latest weather map from the Quic API and can either 
        save it to a file or return the raw image data. The weather map is cached for 
        5 minutes on the server side to reduce load. If saving to a file, the function
        will automatically create the target directory if it doesn't exist.
    
    .PARAMETER OutFile
        Optional. The path where the weather map image should be saved. If not specified, 
        the raw image data will be returned as a byte array. The function will create
        the target directory if it doesn't exist. Supports both absolute and relative paths.
    
    .EXAMPLE
        PS> Get-PSquicWeatherMap -OutFile "C:\temp\weathermap.jpg"
        
        Downloads the weather map and saves it to the specified file. Returns a FileInfo object.
    
    .EXAMPLE
        PS> $imageData = Get-PSquicWeatherMap
        
        Downloads the weather map and stores the raw image data in a variable as byte array.
    
    .EXAMPLE
        PS> $file = Get-PSquicWeatherMap -OutFile "~/Downloads/quic-weather-$(Get-Date -Format 'yyyy-MM-dd').jpg"
        PS> Write-Host "Weather map saved to: $($file.FullName)"
        
        Downloads the weather map with a date-stamped filename and displays the full path.
    
    .EXAMPLE
        PS> Get-PSquicWeatherMap -OutFile "./weather.jpg" -Verbose
        
        Downloads the weather map to the current directory with verbose output.
    
    .INPUTS
        None
        You cannot pipe objects to this function.
    
    .OUTPUTS
        System.Byte[] (if no OutFile specified)
        Raw image data as a byte array that can be processed or saved manually.
        
        System.IO.FileInfo (if OutFile specified)
        A FileInfo object representing the saved file with properties like FullName, Length, etc.
    
    .NOTES
        - Requires an active connection established with Connect-PSquic
        - Weather map data is cached server-side for 5 minutes
        - Target directories are created automatically if they don't exist
        - Supports both absolute and relative file paths
        - The returned FileInfo object can be used for further file operations
    
    .LINK
        Connect-PSquic
    
    .LINK
        Disconnect-PSquic
    
    .LINK
        Get-PSquicServices
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OutFile
    )

    try {
        $uri = "https://api.quic.nz/v1/weathermap"
        
        if ($OutFile) {
            # Ensure the directory exists
            $directory = Split-Path $OutFile -Parent
            if ($directory -and -not (Test-Path $directory)) {
                New-Item -Path $directory -ItemType Directory -Force | Out-Null
                Write-Verbose "Created directory: $directory"
            }
            
            # Download directly to file
            $headers = @{
                "X-API-Key" = $script:ApiKey
            }
            
            if (-not $script:ApiKey) {
                throw "API key not set. Please run Connect-PSquic first."
            }
            
            Invoke-RestMethod -Uri $uri -Method 'GET' -Headers $headers -OutFile $OutFile
            Write-Verbose "Weather map saved to: $OutFile"
            
            return Get-Item $OutFile
        }
        else {
            # Return raw data
            $response = Invoke-PSquicRestMethod -Uri $uri -Method 'GET'
            Write-Verbose "Downloaded $($response.Length) bytes of weather map data"
            return $response
        }
    }
    catch {
        Write-Error "Failed to retrieve weather map: $($_.Exception.Message)"
        throw
    }
}
