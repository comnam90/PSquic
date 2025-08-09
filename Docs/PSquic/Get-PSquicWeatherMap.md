---
document type: cmdlet
external help file: PSquic-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSquic
ms.date: 08/09/2025
PlatyPS schema version: 2024-05-01
title: Get-PSquicWeatherMap
---

# Get-PSquicWeatherMap

## SYNOPSIS

Downloads the latest Quic weather map.

## SYNTAX

### __AllParameterSets

```pwoershell
Get-PSquicWeatherMap [[-OutFile] <string>] [<CommonParameters>]
```

## DESCRIPTION

This function downloads the latest weather map from the Quic API and can either save it to a file or return the raw image data.
The weather map is cached for 5 minutes on the server side to reduce load.
If saving to a file, the function will automatically create the target directory if it doesn't exist.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-PSquicWeatherMap -OutFile "C:\temp\weathermap.jpg"
```

Downloads the weather map and saves it to the specified file.
Returns a FileInfo object.

### EXAMPLE 2

```powershell
$imageData = Get-PSquicWeatherMap
```

Downloads the weather map and stores the raw image data in a variable as byte array.

### EXAMPLE 3

```powershell
$file = Get-PSquicWeatherMap -OutFile "~/Downloads/quic-weather-$(Get-Date -Format 'yyyy-MM-dd').jpg"
PS> Write-Host "Weather map saved to: $($file.FullName)"
```

Downloads the weather map with a date-stamped filename and displays the full path.

### EXAMPLE 4

```powershell
Get-PSquicWeatherMap -OutFile "./weather.jpg" -Verbose
```

Downloads the weather map to the current directory with verbose output.

## PARAMETERS

### -OutFile

Optional.
The path where the weather map image should be saved.
If not specified, the raw image data will be returned as a byte array.
The function will create the target directory if it doesn't exist.
Supports both absolute and relative paths.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
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

### System.Byte[] (if no OutFile specified)

Raw image data as a byte array that can be processed or saved manually.

System.IO.FileInfo (if OutFile specified)
A FileInfo object representing the saved file with properties like FullName

## NOTES

- Requires an active connection established with Connect-PSquic
- Weather map data is cached server-side for 5 minutes
- Target directories are created automatically if they don't exist
- Supports both absolute and relative file paths
- The returned FileInfo object can be used for further file operations

## RELATED LINKS

- [Connect-PSquic](Connect-PSquic.md)
- [Disconnect-PSquic](Disconnect-PSquic.md)
- [Get-PSquicServices](Get-PSquicServices.md)
