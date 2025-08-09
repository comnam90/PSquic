function Get-PSquicSession {
    <#
    .SYNOPSIS
        Retrieves session information for a specific service.
    
    .DESCRIPTION
        This function queries the Quic API to retrieve session data for a specific service,
        or for all available services if no ServiceId is specified. Session details include 
        connection status, active IP addresses, session type, and various network configuration 
        details. Session data is cached for 5 minutes on the server side to reduce load. 
        Supports pipeline input for processing multiple services.
    
    .PARAMETER ServiceId
        Optional. The service identifier to retrieve session information for. This must be a 
        service that the authenticated user is authorized to access. If not specified, the 
        function will automatically retrieve and process all available services. Use 
        Get-PSquicServices to get a list of available service identifiers.
    
    .EXAMPLE
        PS> Get-PSquicSession -ServiceId "service123"
        
        Retrieves session information for service "service123".
    
    .EXAMPLE
        PS> Get-PSquicSession
        
        Retrieves session information for all authorized services automatically.
    
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
        PS> Get-PSquicSession | Where-Object { $_.status -eq 'connected' }
        
        Gets all connected sessions and filters for only connected ones.
    
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
        - When no ServiceId is specified, automatically processes all available services
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
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ServiceIds')]
        [string]$ServiceId
    )

    begin {
        # If no ServiceId is provided via parameter and we're not in pipeline mode,
        # get all available services
        $allServices = @()
        if (-not $PSBoundParameters.ContainsKey('ServiceId') -and -not $MyInvocation.ExpectingInput) {
            try {
                Write-Verbose "No ServiceId specified, retrieving all available services"
                $allServices = Get-PSquicServices
                Write-Verbose "Found $($allServices.Count) services to process"
            }
            catch {
                Write-Error "Failed to retrieve services list: $($_.Exception.Message)"
                throw
            }
            # No initialization needed here; all logic handled in process block.
        }
    }
    process {
        # If we have a specific ServiceId (from parameter or pipeline), process it
        if ($ServiceId) {
            try {
                Write-Verbose "Processing ServiceId: $ServiceId"
                $uri = "https://api.quic.nz/v1/session?service=$ServiceId"
                $response = Invoke-PSquicRestMethod -Uri $uri -Method 'GET'
                
                Write-Output $response
            }
            catch {
                Write-Error "Failed to retrieve session for service '$ServiceId': $($_.Exception.Message)"
                throw
            }
        }
        # Otherwise, process all services we found in the begin block
        elseif ($allServices.Count -gt 0) {
            foreach ($service in $allServices) {
                try {
                    Write-Verbose "Processing service: $service"
                    $uri = "https://api.quic.nz/v1/session?service=$service"
                    $response = Invoke-PSquicRestMethod -Uri $uri -Method 'GET'
                    
                    # Output each session individually so they can be processed in pipeline
                    Write-Output $response
                }
                catch {
                    Write-Error "Failed to retrieve session for service '$service': $($_.Exception.Message)"
                    # Continue processing other services even if one fails
                    continue
                }
            }
        }
    }
}
