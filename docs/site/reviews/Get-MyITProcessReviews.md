---
external help file: MyITProcessAPI-help.xml
grand_parent: reviews
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/reviews/Get-MyITProcessReviews.html
parent: GET
schema: 2.0.0
title: Get-MyITProcessReviews
---

# Get-MyITProcessReviews

## SYNOPSIS
List of reviews

## SYNTAX

### indexByReviews (Default)
```powershell
Get-MyITProcessReviews [-filter_field <String>] [-filter_predicate <String>] [-filter_condition <String>]
 [-filter_operator <String>] [-sort_field <String>] [-sort_direction <String>] [-page <Int64>]
 [-pageSize <Int64>] [-allPages] [<CommonParameters>]
```

### indexByOverdueReviews
```powershell
Get-MyITProcessReviews [-overdue_Reviews] [-filter_field <String>] [-filter_predicate <String>]
 [-filter_condition <String>] [-filter_operator <String>] [-sort_field <String>] [-sort_direction <String>]
 [-page <Int64>] [-pageSize <Int64>] [-allPages] [<CommonParameters>]
```

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

### -overdue_Reviews
Returns a list of categories up for review

```yaml
Type: SwitchParameter
Parameter Sets: indexByOverdueReviews
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_field
Filter by a specific field name

Allowed values:
    'id', 'name', 'status', 'assignedEngineer.id', 'assignedEngineer.fullName', 'assignedVCIO.id',
    'assignedVCIO.fullName', 'createdDate', 'lastUpdatedDate', 'client.id', 'client.name'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sort_field
Sort by a specific field name

Allowed values:
    'id', 'name', 'status', 'assignedEngineer.id', 'assignedEngineer.fullName', 'assignedVCIO.id',
    'assignedVCIO.fullName', 'createdDate', 'lastUpdatedDate', 'client.id', 'client.name'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
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
Position: Named
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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/reviews/Get-MyITProcessReviews.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/reviews/Get-MyITProcessReviews.html)

