function Get-PSquicServices {
    <#
    .SYNOPSIS
        Retrieves the list of services that the authenticated user is authorized to access.
    
    .DESCRIPTION
        This function queries the Quic API to retrieve the list of service identifiers 
        that the authenticated user is authorized to access. Requires a valid API key 
        to be set using Connect-PSquic.
    
    .EXAMPLE
        PS> Get-PSquicServices
        
        Returns an array of service identifiers that the user can access.
    
    .OUTPUTS
        System.String[]
        An array of service identifiers.
    #>
    [CmdletBinding()]
    param()

    try {
        $uri = "https://api.quic.nz/v1/services"
        $response = Invoke-PSquicRestMethod -Uri $uri -Method 'GET'
        
        return $response.serviceIds
    }
    catch {
        Write-Error "Failed to retrieve services: $($_.Exception.Message)"
        throw
    }
}
