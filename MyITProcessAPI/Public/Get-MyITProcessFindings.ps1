function Get-MyITProcessFindings {
<#
    .SYNOPSIS
        List all findings

    .DESCRIPTION
        The Get-MyITProcessFindings cmdlet list all findings

        Findings are located under Strategy > Client > Menu > Initiatives

    .PARAMETER filter_field
        Filter by a specific field name

        Allowed values:
            'id', 'question.label', 'question.text', 'review.id', 'review.name',
            'vcioAnswerType', 'isArchived'

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
            'id', 'question.label', 'question.text', 'review.id', 'review.name',
            'vcioAnswerType', 'isArchived'

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
        Get-MyITProcessFindings

        Returns the first 100 findings

    .EXAMPLE
        Get-MyITProcessFindings -filter_field review.name -filter_predicate contains -filter_condition 'Celerium'

        Returns the findings whose name contains the defined condition

    .EXAMPLE
        Get-MyITProcessFindings -sort_field review.name -sort_direction desc

        Returns the first 100 findings sorted by review.name in descending order

    .EXAMPLE
        Get-MyITProcessFindings -page 2 -pageSize 50

        Returns results 50 at a time and outputs data from page 2

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/findings/Get-MyITProcessFindings.html

#>

    [CmdletBinding()]
    [alias("Get-MipFindings")]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet( 'id', 'question.label', 'question.text', 'review.id', 'review.name', 'vcioAnswerType', 'isArchived' )]
        [string]$filter_field,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains' )]
        [string]$filter_predicate,

        [Parameter( Mandatory = $false )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_condition,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'or', 'and', $null )]
        [AllowNull()]
        [string]$filter_operator,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'id', 'question.label', 'question.text', 'review.id', 'review.name', 'vcioAnswerType', 'isArchived' )]
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

    begin { $resource_uri = '/findings' }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 100 }

        Set-Variable -Name 'MyITProcess_findingsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-MyITProcessRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
