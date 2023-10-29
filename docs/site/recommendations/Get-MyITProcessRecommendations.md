---
external help file: MyITProcessAPI-help.xml
grand_parent: recommendations
Module Name: MyITProcessAPI
online version: https://celerium.github.io/MyITProcess-PowerShellWrapper/site/recommendations/Get-MyITProcessRecommendations.html
parent: GET
schema: 2.0.0
title: Get-MyITProcessRecommendations
---

# Get-MyITProcessRecommendations

## SYNOPSIS
List of recommendations

## SYNTAX

### indexByRecommendation (Default)
```powershell
Get-MyITProcessRecommendations [-filter_field <String>] [-filter_predicate <String>]
 [-filter_condition <String>] [-filter_operator <String>] [-sort_field <String>] [-sort_direction <String>]
 [-page <Int64>] [-pageSize <Int64>] [-allPages] [<CommonParameters>]
```

### indexByRecommendationConfig
```powershell
Get-MyITProcessRecommendations -recommendationId <Int64> [-filter_field <String>] [-filter_predicate <String>]
 [-filter_condition <String>] [-filter_operator <String>] [-sort_field <String>] [-sort_direction <String>]
 [-page <Int64>] [-pageSize <Int64>] [-allPages] [<CommonParameters>]
```

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

### -recommendationId
Defines the recommendation id that in turn will show you any linked configurations

This is a required parameter.

```yaml
Type: Int64
Parameter Sets: indexByRecommendationConfig
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -filter_field
Filter by a specific field name

Allowed values:
    'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
    'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived', 'recommendationFeedback', 'findingsIds'

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
    'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
    'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived', 'recommendationFeedback', 'findingsIds'

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

[https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Recommendations/Get-MyITProcessRecommendations.html](https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Recommendations/Get-MyITProcessRecommendations.html)

