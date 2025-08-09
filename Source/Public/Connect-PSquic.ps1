function Connect-PSquic {
    <#
    .SYNOPSIS
        Connects to the Quic API using an API key for authentication.
    
    .DESCRIPTION
        This function establishes a connection to the Quic API by storing the provided API key
        for use in subsequent API calls. The API key is stored in a script-scoped variable and
        will be automatically included in the X-API-Key header for all API requests made by
        other PSquic functions.
    
    .PARAMETER ApiKey
        The API key for authenticating with the Quic API. This key must be obtained from
        your Quic portal and should have the necessary permissions to access the services
        you intend to query.
    
    .EXAMPLE
        PS> Connect-PSquic -ApiKey "your-api-key-here"
        
        Connects to the Quic API using the specified API key.
    
    .EXAMPLE
        PS> Connect-PSquic -ApiKey $env:QUIC_API_KEY
        
        Connects using an API key stored in an environment variable for security.
    
    .EXAMPLE
        PS> Connect-PSquic -ApiKey (Get-Content "~/quic-api-key.txt" -Raw).Trim()
        
        Connects using an API key read from a secure file.
    
    .INPUTS
        None
        You cannot pipe objects to this function.
    
    .OUTPUTS
        None
        This function does not generate any output.
    
    .NOTES
        - The API key is stored in a script-scoped variable and will persist for the duration
          of the PowerShell session or until Disconnect-PSquic is called.
        - Always use Disconnect-PSquic when finished to clear the stored API key.
        - Keep your API key secure and never hardcode it in scripts that might be shared.
    
    .LINK
        Disconnect-PSquic
    
    .LINK
        Get-PSquicServices
    
    .LINK
        Get-PSquicSession
    
    .LINK
        Get-PSquicWeatherMap
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiKey
    )

    $script:ApiKey = $ApiKey
    Write-Verbose "Connected to Quic API successfully"
}
