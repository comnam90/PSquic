function Disconnect-PSquic {
    <#
    .SYNOPSIS
        Disconnects from the Quic API by clearing the stored API key.
    
    .DESCRIPTION
        This function clears the stored API key that was set using Connect-PSquic.
        After calling this function, you will need to call Connect-PSquic again
        before using other PSquic functions. This function is idempotent and can
        be called safely multiple times.
    
    .EXAMPLE
        PS> Disconnect-PSquic
        
        Clears the stored API key and disconnects from the Quic API.
    
    .EXAMPLE
        PS> Connect-PSquic -ApiKey "your-api-key"
        PS> Get-PSquicServices
        # ... use the API ...
        PS> Disconnect-PSquic
        
        Complete workflow showing connection, usage, and disconnection.
    
    .EXAMPLE
        PS> Disconnect-PSquic -Verbose
        
        Disconnects with verbose output showing the disconnection status.
    
    .INPUTS
        None
        You cannot pipe objects to this function.
    
    .OUTPUTS
        None
        This function does not generate any output.
    
    .NOTES
        - This function is idempotent and can be called multiple times safely.
        - Always call this function when finished with the API to clear credentials.
        - The function will provide verbose output when using the -Verbose parameter.
    
    .LINK
        Connect-PSquic
    
    .LINK
        Get-PSquicServices
    
    .LINK
        Get-PSquicSession
    
    .LINK
        Get-PSquicWeatherMap
    #>
    [CmdletBinding()]
    param()

    if ($script:ApiKey) {
        $script:ApiKey = $null
        Write-Verbose "Disconnected from Quic API - API key cleared"
    }
    else {
        Write-Verbose "Already disconnected - no API key was set"
    }
}
