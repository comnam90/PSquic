function Get-PSquicSession {
    <#
    .SYNOPSIS
        Retrieves session information for a specific service.
    
    .DESCRIPTION
        This function queries the Quic API to retrieve session data for a specific service.
        Session details include connection status, active IP addresses, session type, and 
        various network configuration details. Session data is cached for 5 minutes on the 
        server side to reduce load.
    
    .PARAMETER ServiceId
        The service identifier to retrieve session information for. This must be a service 
        that the authenticated user is authorized to access.
    
    .EXAMPLE
        PS> Get-PSquicSession -ServiceId "service123"
        
        Retrieves session information for service "service123".
    
    .EXAMPLE
        PS> Get-PSquicServices | Get-PSquicSession
        
        Retrieves session information for all authorized services.
    
    .INPUTS
        System.String
        You can pipe service identifiers to this function.
    
    .OUTPUTS
        PSCustomObject
        A custom object containing session information including service details, 
        connection status, IP addresses, and PPP payload data.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ServiceIds')]
        [string]$ServiceId
    )

    process {
        try {
            $uri = "https://api.quic.nz/v1/session?service=$ServiceId"
            $response = Invoke-PSquicRestMethod -Uri $uri -Method 'GET'
            
            return $response
        }
        catch {
            Write-Error "Failed to retrieve session for service '$ServiceId': $($_.Exception.Message)"
            throw
        }
    }
}
