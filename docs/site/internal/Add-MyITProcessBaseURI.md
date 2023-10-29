---
external help file: MyITProcessAPI-help.xml
grand_parent: internal
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Add-MyITProcessBaseURI.html
parent: POST
schema: 2.0.0
title: Add-MyITProcessBaseURI
---

# Add-MyITProcessBaseURI

## SYNOPSIS
Sets the base URI for the MyITProcess API connection.

## SYNTAX

```powershell
Add-MyITProcessBaseURI [[-base_uri] <String>] [[-data_center] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-MyITProcessBaseURI cmdlet sets the base URI which is later used to construct the full URI for all API calls.

## EXAMPLES

### EXAMPLE 1
```powershell
Add-MyITProcessBaseURI
```

The base URI will use https://reporting.live.myitprocess.com/public-api/v1 which is MyITProcess's default URI.

### EXAMPLE 2
```powershell
Add-MyITProcessBaseURI -data_center US
```

The base URI will use https://reporting.live.myitprocess.com/public-api/v1 which is MyITProcess's default URI.

### EXAMPLE 3
```powershell
Add-MyITProcessBaseURI -base_uri http://myapi.gateway.example.com
```

A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to MyITProcess's reporting API.

## PARAMETERS

### -base_uri
Define the base URI for the MyITProcess API connection using MyITProcess's URI or a custom URI.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://reporting.live.myitprocess.com/public-api/v1
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -data_center
MyITProcess's URI connection point that can be one of the predefined data centers.
The accepted values for this parameter are:
\[ US \]
US = https://reporting.live.myitprocess.com/public-api/v1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Add-MyITProcessBaseURI.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Add-MyITProcessBaseURI.html)

