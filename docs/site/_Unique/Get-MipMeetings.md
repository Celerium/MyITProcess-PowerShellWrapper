---
external help file: MyITProcessAPI-help.xml
grand_parent: _Unique
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/_Unique/Get-MipMeetings.html
parent: Special
schema: 2.0.0
title: Get-MipMeetings
---

# Get-MipMeetings

## SYNOPSIS
List of meetings

## SYNTAX

## DESCRIPTION
The Get-MyITProcessMeetings cmdlet gets a list of meetings

Meetings are located under Strategy \> Client \> Menu \> Meeting History

## EXAMPLES

### EXAMPLE 1
```powershell
Get-MyITProcessMeetings
```

Returns the first 100 meetings

### EXAMPLE 2
```powershell
Get-MyITProcessMeetings -filter_field title -filter_predicate equal -filter_condition 'Celerium'
```

Returns the meetings whose title equals the defined condition

### EXAMPLE 3
```powershell
Get-MyITProcessMeetings -sort_field title -sort_direction desc
```

Returns the first 100 meetings sorted by title in descending order

### EXAMPLE 4
```powershell
Get-MyITProcessMeetings -page 2 -pageSize 50
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Meetings/Get-MyITProcessMeetings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Meetings/Get-MyITProcessMeetings.html)

