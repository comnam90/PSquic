function Get-PSquicServices {
    <#
    .SYNOPSIS
        Retrieves the list of services that the authenticated user is authorized to access.
    
    .DESCRIPTION
        This function queries the Quic API to retrieve the list of service identifiers 
        that the authenticated user is authorized to access. The service identifiers can
        then be used with Get-PSquicSession to retrieve detailed session information.
        Requires a valid API key to be set using Connect-PSquic.
    
    .EXAMPLE
        PS> Get-PSquicServices
        
        Returns an array of service identifiers that the user can access.
    
    .EXAMPLE
        PS> $services = Get-PSquicServices
        PS> Write-Host "You have access to $($services.Count) services: $($services -join ', ')"
        
        Retrieves services and displays count and list.
    
    .EXAMPLE
        PS> Get-PSquicServices | Get-PSquicSession
        
        Uses pipeline to get session information for all authorized services.
    
    .INPUTS
        None
        You cannot pipe objects to this function.
    
    .OUTPUTS
        System.String[]
        An array of service identifiers that can be used with other PSquic functions.
    
    .NOTES
        - Requires an active connection established with Connect-PSquic
        - The returned service IDs can be used with Get-PSquicSession
        - This function supports pipeline output to other PSquic functions
    
    .LINK
        Connect-PSquic
    
    .LINK
        Get-PSquicSession
    
    .LINK
        Disconnect-PSquic
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
