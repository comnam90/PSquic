function Get-PSquicSession {
    <#
    .SYNOPSIS
        Retrieves session information for a specific service.
    
    .DESCRIPTION
        This function queries the Quic API to retrieve session data for a specific service.
        Session details include connection status, active IP addresses, session type, and 
        various network configuration details. Session data is cached for 5 minutes on the 
        server side to reduce load. Supports pipeline input for processing multiple services.
    
    .PARAMETER ServiceId
        The service identifier to retrieve session information for. This must be a service 
        that the authenticated user is authorized to access. Use Get-PSquicServices to get
        a list of available service identifiers.
    
    .EXAMPLE
        PS> Get-PSquicSession -ServiceId "service123"
        
        Retrieves session information for service "service123".
    
    .EXAMPLE
        PS> Get-PSquicServices | Get-PSquicSession
        
        Retrieves session information for all authorized services using pipeline.
    
    .EXAMPLE
        PS> $session = Get-PSquicSession -ServiceId "service123"
        PS> Write-Host "Service status: $($session.status)"
        PS> Write-Host "Session type: $($session.sessionType)"
        PS> Write-Host "IPv4 Address: $($session.activeIPv4Prefix)"
        
        Retrieves session information and displays key properties.
    
    .EXAMPLE
        PS> Get-PSquicServices | Get-PSquicSession | Where-Object { $_.status -eq 'connected' }
        
        Gets all connected sessions using pipeline and filtering.
    
    .INPUTS
        System.String
        You can pipe service identifiers to this function from Get-PSquicServices.
    
    .OUTPUTS
        PSCustomObject
        A custom object containing session information with properties including:
        - service: Service details (username, status, entity information)
        - status: Connection status
        - sessionType: Type of session (e.g., DHCP, PPP)
        - activeIPv4Prefix: Active IPv4 address
        - activeIPv6Prefix: Active IPv6 address (if available)
        - And other network configuration details
    
    .NOTES
        - Requires an active connection established with Connect-PSquic
        - Session data is cached server-side for 5 minutes
        - Supports both single service queries and pipeline processing
        - The ServiceIds alias is provided for backwards compatibility
    
    .LINK
        Connect-PSquic
    
    .LINK
        Get-PSquicServices
    
    .LINK
        Disconnect-PSquic
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
