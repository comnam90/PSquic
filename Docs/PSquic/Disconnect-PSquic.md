---
document type: cmdlet
external help file: PSquic-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSquic
ms.date: 08/09/2025
PlatyPS schema version: 2024-05-01
title: Disconnect-PSquic
---

# Disconnect-PSquic

## SYNOPSIS

Disconnects from the Quic API by clearing the stored API key.

## SYNTAX

### __AllParameterSets

```powershell
Disconnect-PSquic [<CommonParameters>]
```

## DESCRIPTION

This function clears the stored API key that was set using Connect-PSquic.
After calling this function, you will need to call Connect-PSquic again
before using other PSquic functions.
This function is idempotent and can be called safely multiple times.

## EXAMPLES

### EXAMPLE 1

```powershell
Disconnect-PSquic
```

Clears the stored API key and disconnects from the Quic API.

### EXAMPLE 2

```powershell
Connect-PSquic -ApiKey "your-api-key"
PS> Get-PSquicServices
# ... use the API ...
PS> Disconnect-PSquic
```

Complete workflow showing connection, usage, and disconnection.

### EXAMPLE 3

```powershell
Disconnect-PSquic -Verbose
```

Disconnects with verbose output showing the disconnection status.

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

### None

This function does not generate any output.

## NOTES

- This function is idempotent and can be called multiple times safely.
- Always call this function when finished with the API to clear credentials.
- The function will provide verbose output when using the -Verbose parameter.


## RELATED LINKS

- [Connect-PSquic](Connect-PSquic.ps1)
- [Get-PSquicServices](Get-PSquicServices.ps1)
- [Get-PSquicSession](Get-PSquicSession.ps1)
- [Get-PSquicWeatherMap](Get-PSquicWeatherMap.ps1)
