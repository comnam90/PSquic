function Connect-PSquic {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApiKey
    )

    $script:ApiKey = $ApiKey
}
