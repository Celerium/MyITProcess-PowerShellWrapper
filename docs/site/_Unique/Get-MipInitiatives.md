---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Get-MipInitiatives.html
parent: Special
schema: 2.0.0
title: Get-MipInitiatives
---

# Get-MipInitiatives

## SYNOPSIS
List of initiatives

## SYNTAX

## DESCRIPTION
The Get-MyITProcessInitiatives cmdlet gets a list of initiatives

Initiatives are located under Strategy \> Client \> Menu \> Initiatives

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessInitiatives
```

Returns the first 100 initiatives

### EXAMPLE 2
```powershell
Get-MyITProcessInitiatives -filter_field client.id -filter_predicate equal -filter_condition '123456789'
```

Returns the initiatives whose client.id equals the defined condition

### EXAMPLE 3
```powershell
Get-MyITProcessInitiatives -sort_field client.id -sort_direction desc
```

Returns the first 100 initiatives sorted by client.id in descending order

### EXAMPLE 4
```powershell
Get-MyITProcessInitiatives -page 2 -pageSize 50
```

Returns results 50 at a time and outputs data from page 2

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Initiatives/Get-MyITProcessInitiatives.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Initiatives/Get-MyITProcessInitiatives.html)

