---
external help file: MyITProcessAPI-help.xml
grand_parent: internal
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Test-MyITProcessAPIKey.html
parent: GET
schema: 2.0.0
title: Test-MyITProcessAPIKey
---

# Test-MyITProcessAPIKey

## SYNOPSIS
Test the MyITProcess API key.

## SYNTAX

```powershell
Test-MyITProcessAPIKey [[-base_uri] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Test-MyITProcessAPIKey cmdlet tests the base URI & API key that was defined in the
Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

This functions validates authorization to the /users endpoint

## EXAMPLES

### EXAMPLE 1
```powershell
Test-MyITProcessBaseURI
```

Tests the base URI & API key that was defined in the
Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

The default full base uri test path is:
    https://reporting.live.myitprocess.com/api/v1/clients

### EXAMPLE 2
```powershell
Test-MyITProcessBaseURI -base_uri http://myapi.gateway.example.com
```

Tests the base URI & API key that was defined in the
Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

The full base uri test path in this example is:
    http://myapi.gateway.example.com/clients

## PARAMETERS

### -base_uri
Define the base URI for the MyITProcess API connection using MyITProcess's URI or a custom URI.

The default base URI is https://reporting.live.myitprocess.com/api/v1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $MyITProcess_Base_URI
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Test-MyITProcessAPIKey.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Test-MyITProcessAPIKey.html)

