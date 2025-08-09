---
document type: cmdlet
external help file: PSquic-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSquic
ms.date: 08/09/2025
PlatyPS schema version: 2024-05-01
title: Get-PSquicServices
---

# Get-PSquicServices

## SYNOPSIS

Retrieves the list of services that the authenticated user is authorized to access.

## SYNTAX

### __AllParameterSets

```powershell
Get-PSquicServices [<CommonParameters>]
```

## DESCRIPTION

This function queries the Quic API to retrieve the list of service identifiers 
that the authenticated user is authorized to access.
The service identifiers can then be used with Get-PSquicSession to retrieve detailed session information.
Requires a valid API key to be set using Connect-PSquic.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-PSquicServices
```

Returns an array of service identifiers that the user can access.

### EXAMPLE 2

```powershell
$services = Get-PSquicServices
PS> Write-Host "You have access to $($services.Count) services: $($services -join ', ')"
```

Retrieves services and displays count and list.

### EXAMPLE 3

```powershell
Get-PSquicServices | Get-PSquicSession
```

Uses pipeline to get session information for all authorized services.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

You cannot pipe objects to this function.

## OUTPUTS

### System.String[]

An array of service identifiers that can be used with other PSquic functions.

## NOTES

- Requires an active connection established with Connect-PSquic
- The returned service IDs can be used with Get-PSquicSession
- This function supports pipeline output to other PSquic functions

## RELATED LINKS

- [Connect-PSquic](Connect-PSquic.md)
- [Get-PSquicSession](Get-PSquicSession.md)
- [Disconnect-PSquic](Disconnect-PSquic.md)
