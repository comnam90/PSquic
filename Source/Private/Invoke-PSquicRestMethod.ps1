function Invoke-PSquicRestMethod {
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
        "Authorization" = "Bearer $script:ApiKey"
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
