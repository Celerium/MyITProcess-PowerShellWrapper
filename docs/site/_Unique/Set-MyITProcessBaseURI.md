---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Set-MyITProcessBaseURI.html
parent: Special
schema: 2.0.0
title: Set-MyITProcessBaseURI
---

# Set-MyITProcessBaseURI

## SYNOPSIS
Sets the base URI for the MyITProcess API connection.

## SYNTAX

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Add-MyITProcessBaseURI.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Add-MyITProcessBaseURI.html)

