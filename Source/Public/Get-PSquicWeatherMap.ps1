function Get-PSquicWeatherMap {
    <#
    .SYNOPSIS
        Downloads the latest Quic weather map.
    
    .DESCRIPTION
        This function downloads the latest weather map from the Quic API and can either 
        save it to a file or return the raw image data. The weather map is cached for 
        5 minutes on the server side to reduce load.
    
    .PARAMETER OutFile
        Optional. The path where the weather map image should be saved. If not specified, 
        the raw image data will be returned.
    
    .EXAMPLE
        PS> Get-PSquicWeatherMap -OutFile "C:\temp\weathermap.jpg"
        
        Downloads the weather map and saves it to the specified file.
    
    .EXAMPLE
        PS> $imageData = Get-PSquicWeatherMap
        
        Downloads the weather map and stores the raw image data in a variable.
    
    .OUTPUTS
        System.Byte[] (if no OutFile specified)
        System.IO.FileInfo (if OutFile specified)
        
        Returns either the raw image data as a byte array, or a FileInfo object 
        representing the saved file.
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
            }
            
            # Download directly to file
            $headers = @{
                "X-API-Key" = $script:ApiKey
            }
            
            if (-not $script:ApiKey) {
                throw "API key not set. Please run Connect-PSquic first."
            }
            
            Invoke-RestMethod -Uri $uri -Method 'GET' -Headers $headers -OutFile $OutFile
            
            return Get-Item $OutFile
        }
        else {
            # Return raw data
            $response = Invoke-PSquicRestMethod -Uri $uri -Method 'GET'
            return $response
        }
    }
    catch {
        Write-Error "Failed to retrieve weather map: $($_.Exception.Message)"
        throw
    }
}
