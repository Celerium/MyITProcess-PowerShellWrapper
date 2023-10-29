---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Test-MipAPIKey.html
parent: Special
schema: 2.0.0
title: Test-MipAPIKey
---

# Test-MipAPIKey

## SYNOPSIS
Test the MyITProcess API key.

## SYNTAX

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Test-MyITProcessAPIKey.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Test-MyITProcessAPIKey.html)

