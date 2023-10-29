function Get-MyITProcessRecommendations {
<#
    .SYNOPSIS
        List of recommendations

    .DESCRIPTION
        The Get-MyITProcessRecommendations cmdlet gets a list of recommendations

        Meetings are located under Strategy > Client > Menu > Recommendation backlog

    .PARAMETER recommendationId
        Defines the recommendation id that in turn will show you any linked configurations

        This is a required parameter.

    .PARAMETER filter_field
        Filter by a specific field name

        Allowed values:
            'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
            'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived', 'recommendationFeedback', 'findingsIds'

    .PARAMETER filter_predicate
        Filter by a specific field predicate operator

        Allowed values:
            'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains'

    .PARAMETER filter_condition
        Filter by a value in the specified field.

        This value cannot be empty

    .PARAMETER filter_operator
        Also filter for other values

        Allowed values:
            'and', 'or', $null

        This parameter is just a placeholder for now as I am unsure how
        to add this functionality if multiple queries are needed

    .PARAMETER sort_field
        Sort by a specific field name

        Allowed values:
            'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
            'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived', 'recommendationFeedback', 'findingsIds'

    .PARAMETER sort_direction
        Sort the specific field name in a certain direction

        Allowed values:
            'asc', 'desc'

    .PARAMETER page
        Defines the page number to return

        [Default] 1

    .PARAMETER pageSize
        Defines the number of items to return with each page

        [Default] 100
        [Maximum] 100

    .PARAMETER allPages
        Returns all items from an endpoint

    .EXAMPLE
        Get-MyITProcessRecommendations

        Returns the first 100 recommendations

    .EXAMPLE
        Get-MyITProcessRecommendations -filter_field name -filter_predicate contains -filter_condition 'Celerium'

        Returns the recommendations whose name contains the defined condition

    .EXAMPLE
        Get-MyITProcessRecommendations -sort_field name -sort_direction desc

        Returns the first 100 recommendations sorted by name in descending order

    .EXAMPLE
        Get-MyITProcessRecommendations -page 2 -pageSize 50

        Returns results 50 at a time and outputs data from page 2

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/recommendations/Get-MyITProcessRecommendations.html

#>

    [CmdletBinding(DefaultParameterSetName = 'indexByRecommendation')]
    [alias("Get-MipRecommendations")]
    Param (
        [Parameter( Mandatory = $true, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$recommendationId,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateSet(   'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
                        'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived', 'recommendationFeedback', 'findingsIds' )]
        [string]$filter_field,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateSet( 'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains' )]
        [string]$filter_predicate,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [string]$filter_condition,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateSet( 'or', 'and', $null )]
        [AllowNull()]
        [string]$filter_operator,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateSet(   'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
                        'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived', 'recommendationFeedback', 'findingsIds' )]
        [string]$sort_field,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateSet( 'asc', 'desc' )]
        [string]$sort_direction,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [ValidateRange(1,100)]
        [int64]$pageSize,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendation' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByRecommendationConfig' )]
        [switch]$allPages
    )

    begin {

        switch ($($PSCmdlet.ParameterSetName)){
            'indexByRecommendation'         { $resource_uri = '/recommendations' }
            'indexByRecommendationConfig'   { $resource_uri = "/recommendations/$recommendationId/configurations" }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 100 }

        Set-Variable -Name 'MyITProcess_recommendationsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-MyITProcessRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}