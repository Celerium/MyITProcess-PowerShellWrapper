---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Get-MipRecommendations.html
parent: Special
schema: 2.0.0
title: Get-MipRecommendations
---

# Get-MipRecommendations

## SYNOPSIS
List of recommendations

## SYNTAX

## DESCRIPTION
The Get-MyITProcessRecommendations cmdlet gets a list of recommendations

Meetings are located under Strategy \> Client \> Menu \> Recommendation backlog

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessRecommendations
```

Returns the first 100 recommendations

### EXAMPLE 2
```powershell
Get-MyITProcessRecommendations -filter_field name -filter_predicate contains -filter_condition 'Celerium'
```

Returns the recommendations whose name contains the defined condition

### EXAMPLE 3
```powershell
Get-MyITProcessRecommendations -sort_field name -sort_direction desc
```

Returns the first 100 recommendations sorted by name in descending order

### EXAMPLE 4
```powershell
Get-MyITProcessRecommendations -page 2 -pageSize 50
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Recommendations/Get-MyITProcessRecommendations.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Recommendations/Get-MyITProcessRecommendations.html)

