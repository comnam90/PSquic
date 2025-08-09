function Invoke-PSquicRestMethod {
    <#
    .SYNOPSIS
        Internal helper function for making authenticated REST API calls to the Quic API.
    
    .DESCRIPTION
        This private function provides a centralized method for making HTTP requests to
        the Quic API with proper authentication headers. It handles API key validation
        and standardizes the request format across all public functions.
    
    .PARAMETER Uri
        The full URI for the API endpoint to call.
    
    .PARAMETER Method
        The HTTP method to use. Defaults to 'GET'.
    
    .PARAMETER Body
        Optional request body for POST/PUT requests.
    
    .NOTES
        This is a private function not intended for direct use by module consumers.
        It requires the $script:ApiKey variable to be set by Connect-PSquic.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        [Parameter(Mandatory = $false)]
        [string]$Method = 'GET',

        [Parameter(Mandatory = $false)]
        [object]$Body
    )

    if (-not $script:ApiKey) {
        throw "API key not set. Please run Connect-PSquic first."
    }

    $headers = @{
        "X-API-Key" = $script:ApiKey
    }

    $params = @{
        Uri = $Uri
        Method = $Method
        Headers = $headers
    }

    if ($Body) {
        $params.Body = $Body
        $params.ContentType = 'application/json'
    }

    Invoke-RestMethod @params
}
