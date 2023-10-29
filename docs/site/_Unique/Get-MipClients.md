---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Get-MipClients.html
parent: Special
schema: 2.0.0
title: Get-MipClients
---

# Get-MipClients

## SYNOPSIS
Lists all clients (both active and inactive)

## SYNTAX

## DESCRIPTION
The Get-MyITProcessClients cmdlet lists all clients (both active and inactive)

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessClients
```

Returns the first 100 clients

### EXAMPLE 2
```powershell
Get-MyITProcessClients -filter_field name -filter_predicate equal -filter_condition 'Celerium'
```

Returns the clients whose name equals the defined condition

### EXAMPLE 3
```powershell
Get-MyITProcessClients -sort_field name -sort_direction desc
```

Returns the first 100 clients sorted by name in descending order

### EXAMPLE 4
```powershell
Get-MyITProcessClients -page 2 -pageSize 50
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Clients/Get-MyITProcessClients.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Clients/Get-MyITProcessClients.html)

