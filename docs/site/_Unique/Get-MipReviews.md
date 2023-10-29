---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Get-MipReviews.html
parent: Special
schema: 2.0.0
title: Get-MipReviews
---

# Get-MipReviews

## SYNOPSIS
List of reviews

## SYNTAX

## DESCRIPTION
The Get-MyITProcessReviews cmdlet gets a list of reviews

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessReviews
```

Returns the first 100 reviews

### EXAMPLE 2
```powershell
Get-MyITProcessReviews -overdue_Reviews
```

Returns the first 100 overdue reviews

### EXAMPLE 3
```powershell
Get-MyITProcessReviews -filter_field name -filter_predicate contains -filter_condition 'Celerium'
```

Returns the reviews whose name contains the defined condition

### EXAMPLE 4
```powershell
Get-MyITProcessReviews -sort_field name -sort_direction desc
```

Returns the first 100 reviews sorted by name in descending order

### EXAMPLE 5
```powershell
Get-MyITProcessReviews -page 2 -pageSize 50
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/reviews/Get-MyITProcessReviews.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/reviews/Get-MyITProcessReviews.html)

