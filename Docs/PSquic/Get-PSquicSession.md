---
document type: cmdlet
external help file: PSquic-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSquic
ms.date: 08/09/2025
PlatyPS schema version: 2024-05-01
title: Get-PSquicSession
---

# Get-PSquicSession

## SYNOPSIS

Retrieves session information for a specific service.

## SYNTAX

### __AllParameterSets

```powersehll
Get-PSquicSession [[-ServiceId] <string>] [<CommonParameters>]
```

## DESCRIPTION

This function queries the Quic API to retrieve session data for a specific service,
or for all available services if no ServiceId is specified.
Session details include connection status, active IP addresses, session type, and various network configuration details.
Session data is cached for 5 minutes on the server side to reduce load.

Supports pipeline input for processing multiple services.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-PSquicSession -ServiceId "service123"
```

Retrieves session information for service "service123".

### EXAMPLE 2

```powershell
Get-PSquicSession
```

Retrieves session information for all authorized services automatically.

### EXAMPLE 3

```powershell
Get-PSquicServices | Get-PSquicSession
```

Retrieves session information for all authorized services using pipeline.

### EXAMPLE 4

```powershell
$session = Get-PSquicSession -ServiceId "service123"
PS> Write-Host "Service status: $($session.status)"
PS> Write-Host "Session type: $($session.sessionType)"
PS> Write-Host "IPv4 Address: $($session.activeIPv4Prefix)"
```

Retrieves session information and displays key properties.

### EXAMPLE 5

```powershell
Get-PSquicSession | Where-Object { $_.status -eq 'connected' }
```

Gets all connected sessions and filters for only connected ones.

## PARAMETERS

### -ServiceId

Optional.
The service identifier to retrieve session information for.
This must be a service that the authenticated user is authorized to access.
If not specified, the function will automatically retrieve and process all available services.
Use Get-PSquicServices to get a list of available service identifiers.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- ServiceIds
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

### System.String

You can pipe service identifiers to this function from Get-PSquicServices.

## OUTPUTS

### PSCustomObject

A custom object containing session information with properties including:

- service: Service details (username

## NOTES

- Requires an active connection established with Connect-PSquic
- Session data is cached server-side for 5 minutes
- Supports both single service queries and pipeline processing
- When no ServiceId is specified, automatically processes all available services
- The ServiceIds alias is provided for backwards compatibility

## RELATED LINKS

- [Connect-PSquic](Connect-PSquic.md)
- [Get-PSquicServices](Get-PSquicServices.md)
- [Disconnect-PSquic](Disconnect-PSquic.md)
