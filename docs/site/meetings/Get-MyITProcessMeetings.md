---
external help file: MyITProcessAPI-help.xml
grand_parent: meetings
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/meetings/Get-MyITProcessMeetings.html
parent: GET
schema: 2.0.0
title: Get-MyITProcessMeetings
---

# Get-MyITProcessMeetings

## SYNOPSIS
List of meetings

## SYNTAX

```powershell
Get-MyITProcessMeetings [[-filter_field] <String>] [[-filter_predicate] <String>]
 [[-filter_condition] <String>] [[-filter_operator] <String>] [[-sort_field] <String>]
 [[-sort_direction] <String>] [[-page] <Int64>] [[-pageSize] <Int64>] [-allPages] [<CommonParameters>]
```

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

### -filter_field
Filter by a specific field name

Allowed values:
    'id', 'status', 'title', 'purpose', 'startDate', 'endDate', 'location', 'summaryDescription',
    'recommendationIds', 'client.id', 'client.name', 'createdBy.id', 'createdBy.fullName'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_predicate
Filter by a specific field predicate operator

Allowed values:
    'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_condition
Filter by a value in the specified field.

This value cannot be empty

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_operator
Also filter for other values

Allowed values:
    'and', 'or', $null

This parameter is just a placeholder for now as I am unsure how
to add this functionality if multiple queries are needed

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sort_field
Sort by a specific field name

Allowed values:
    'id', 'status', 'title', 'purpose', 'startDate', 'endDate', 'location', 'summaryDescription',
    'recommendationIds', 'client.id', 'client.name', 'createdBy.id', 'createdBy.fullName'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sort_direction
Sort the specific field name in a certain direction

Allowed values:
    'asc', 'desc'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -page
Defines the page number to return

\[Default\] 1

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
Defines the number of items to return with each page

\[Default\] 100
\[Maximum\] 100

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N\A

## RELATED LINKS

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Meetings/Get-MyITProcessMeetings.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Meetings/Get-MyITProcessMeetings.html)

