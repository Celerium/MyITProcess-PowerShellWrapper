function Get-MyITProcessMeetings {
<#
    .SYNOPSIS
        List of meetings

    .DESCRIPTION
        The Get-MyITProcessMeetings cmdlet gets a list of meetings

        Meetings are located under Strategy > Client > Menu > Meeting History

    .PARAMETER filter_field
        Filter by a specific field name

        Allowed values:
            'id', 'status', 'title', 'purpose', 'startDate', 'endDate', 'location', 'summaryDescription',
            'recommendationIds', 'client.id', 'client.name', 'createdBy.id', 'createdBy.fullName'

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
            'id', 'status', 'title', 'purpose', 'startDate', 'endDate', 'location', 'summaryDescription',
            'recommendationIds', 'client.id', 'client.name', 'createdBy.id', 'createdBy.fullName'

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
        Get-MyITProcessMeetings

        Returns the first 100 meetings

    .EXAMPLE
        Get-MyITProcessMeetings -filter_field title -filter_predicate equal -filter_condition 'Celerium'

        Returns the meetings whose title equals the defined condition

    .EXAMPLE
        Get-MyITProcessMeetings -sort_field title -sort_direction desc

        Returns the first 100 meetings sorted by title in descending order

    .EXAMPLE
        Get-MyITProcessMeetings -page 2 -pageSize 50

        Returns results 50 at a time and outputs data from page 2

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Meetings/Get-MyITProcessMeetings.html

#>

    [CmdletBinding()]
    [alias("Get-MipMeetings")]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet(   'id', 'status', 'title', 'purpose', 'startDate', 'endDate', 'location', 'summaryDescription',
                        'recommendationIds', 'client.id', 'client.name', 'createdBy.id', 'createdBy.fullName' )]
        [string]$filter_field,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains' )]
        [string]$filter_predicate,

        [Parameter( Mandatory = $false )]
        [string]$filter_condition,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'or', 'and', $null )]
        [AllowNull()]
        [string]$filter_operator,

        [Parameter( Mandatory = $false )]
        [ValidateSet(   'id', 'status', 'title', 'purpose', 'startDate', 'endDate', 'location', 'summaryDescription',
                        'recommendationIds', 'client.id', 'client.name', 'createdBy.id', 'createdBy.fullName' )]
        [string]$sort_field,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'asc', 'desc' )]
        [string]$sort_direction,

        [Parameter( Mandatory = $false )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page,

        [Parameter( Mandatory = $false )]
        [ValidateRange(1,100)]
        [int64]$pageSize,

        [Parameter( Mandatory = $false )]
        [switch]$allPages
    )

    begin { $resource_uri = '/meetings' }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 100 }

        Set-Variable -Name 'MyITProcess_meetingsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-MyITProcessRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
