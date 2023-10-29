---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Get-MipUsers.html
parent: Special
schema: 2.0.0
title: Get-MipUsers
---

# Get-MipUsers

## SYNOPSIS
List of users

## SYNTAX

## DESCRIPTION
The Get-MyITProcessUsers cmdlet gets a List of users

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessUsers
```

Returns the first 100 users

### EXAMPLE 2
```powershell
Get-MyITProcessUsers -filter_field firstName -filter_predicate equal -filter_condition 'Celerium'
```

Returns the users whose firstName equals the defined condition

### EXAMPLE 3
```powershell
Get-MyITProcessUsers -sort_field firstName -sort_direction desc
```

Returns the first 100 users sorted by firstName in descending order

### EXAMPLE 4
```powershell
Get-MyITProcessUsers -page 2 -pageSize 50
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/users/Get-MyITProcessUsers.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/users/Get-MyITProcessUsers.html)

