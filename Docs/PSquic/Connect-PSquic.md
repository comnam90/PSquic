---
document type: cmdlet
external help file: PSquic-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSquic
ms.date: 08/09/2025
PlatyPS schema version: 2024-05-01
title: Connect-PSquic
---

# Connect-PSquic

## SYNOPSIS

Connects to the Quic API using an API key for authentication.

## SYNTAX

### __AllParameterSets

```powershell
Connect-PSquic [-ApiKey] <string> [<CommonParameters>]
```

## DESCRIPTION

This function establishes a connection to the Quic API by storing the provided API key
for use in subsequent API calls.
The API key is stored in a script-scoped variable and will be automatically included in the X-API-Key header for all API requests made by other PSquic functions.

## EXAMPLES

### EXAMPLE 1

```powershell
Connect-PSquic -ApiKey "your-api-key-here"
```

Connects to the Quic API using the specified API key.

### EXAMPLE 2

```powershell
Connect-PSquic -ApiKey $env:QUIC_API_KEY
```

Connects using an API key stored in an environment variable for security.

### EXAMPLE 3

```powershell
Connect-PSquic -ApiKey (Get-Content "~/quic-api-key.txt" -Raw).Trim()
```

Connects using an API key read from a secure file.

## PARAMETERS

### -ApiKey

The API key for authenticating with the Quic API.
This key must be obtained from your Quic portal and should have the necessary permissions to access the services you intend to query.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

You cannot pipe objects to this function.

## OUTPUTS

### None

This function does not generate any output.

## NOTES

- The API key is stored in a script-scoped variable and will persist for the duration
  of the PowerShell session or until Disconnect-PSquic is called.
- Always use Disconnect-PSquic when finished to clear the stored API key.
- Keep your API key secure and never hardcode it in scripts that might be shared.


## RELATED LINKS

- [Disconnect-PSquic](Disconnect-PSquic.md)
- [Get-PSquicServices](Get-PSquicServices.md)
- [Get-PSquicSession](Get-PSquicSession.md)
- [Get-PSquicWeatherMap](Get-PSquicWeatherMap.md)
