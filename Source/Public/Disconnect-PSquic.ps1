function Disconnect-PSquic {
    <#
    .SYNOPSIS
        Disconnects from the Quic API by clearing the stored API key.
    
    .DESCRIPTION
        This function clears the stored API key that was set using Connect-PSquic.
        After calling this function, you will need to call Connect-PSquic again
        before using other PSquic functions.
    
    .EXAMPLE
        PS> Disconnect-PSquic
        
        Clears the stored API key and disconnects from the Quic API.
    
    .EXAMPLE
        PS> Connect-PSquic -ApiKey "your-api-key"
        PS> Get-PSquicServices
        # ... use the API ...
        PS> Disconnect-PSquic
        
        Complete workflow showing connection, usage, and disconnection.
    
    .OUTPUTS
        None
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
