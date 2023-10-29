---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Get-MipFindings.html
parent: Special
schema: 2.0.0
title: Get-MipFindings
---

# Get-MipFindings

## SYNOPSIS
List all findings

## SYNTAX

## DESCRIPTION
The Get-MyITProcessFindings cmdlet list all findings

Findings are located under Strategy \> Client \> Menu \> Initiatives

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessFindings
```

Returns the first 100 findings

### EXAMPLE 2
```powershell
Get-MyITProcessFindings -filter_field review.name -filter_predicate contains -filter_condition 'Celerium'
```

Returns the findings whose name contains the defined condition

### EXAMPLE 3
```powershell
Get-MyITProcessFindings -sort_field review.name -sort_direction desc
```

Returns the first 100 findings sorted by review.name in descending order

### EXAMPLE 4
```powershell
Get-MyITProcessFindings -page 2 -pageSize 50
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/findings/Get-MyITProcessFindings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/findings/Get-MyITProcessFindings.html)

