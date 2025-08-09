@{
    RootModule = 'PSquic.psm1'
    ModuleVersion = '0.0.1'
    GUID = 'dac8ec99-5044-4dda-b86e-bbfa51e8198c'
    Author = 'Ben Thomas'
    CompanyName = 'GarageCloud'
    Copyright = '(c) 2025 Ben Thomas. All rights reserved.'
    Description = 'PowerShell module for interacting with the Quic API to retrieve session data, services, and weather maps.'
    PowerShellVersion = '5.1'
    RequiredModules = @()
    FunctionsToExport = @('Connect-PSquic', 'Disconnect-PSquic', 'Get-PSquicServices', 'Get-PSquicSession', 'Get-PSquicWeatherMap')
    CmdletsToExport = @()
    VariablesToExport = '*'
    AliasesToExport = '*'
}
