function Get-MyITProcessReviews {
<#
    .SYNOPSIS
        List of reviews

    .DESCRIPTION
        The Get-MyITProcessReviews cmdlet gets a list of reviews

    .PARAMETER overdue_Reviews
        Returns a list of categories up for review

    .PARAMETER filter_field
        Filter by a specific field name

        Allowed values:
            'id', 'name', 'status', 'assignedEngineer.id', 'assignedEngineer.fullName', 'assignedVCIO.id',
            'assignedVCIO.fullName', 'createdDate', 'lastUpdatedDate', 'client.id', 'client.name'

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
            'id', 'name', 'status', 'assignedEngineer.id', 'assignedEngineer.fullName', 'assignedVCIO.id',
            'assignedVCIO.fullName', 'createdDate', 'lastUpdatedDate', 'client.id', 'client.name'

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
        Get-MyITProcessReviews

        Returns the first 100 reviews

    .EXAMPLE
        Get-MyITProcessReviews -overdue_Reviews

        Returns the first 100 overdue reviews

    .EXAMPLE
        Get-MyITProcessReviews -filter_field name -filter_predicate contains -filter_condition 'Celerium'

        Returns the reviews whose name contains the defined condition

    .EXAMPLE
        Get-MyITProcessReviews -sort_field name -sort_direction desc

        Returns the first 100 reviews sorted by name in descending order

    .EXAMPLE
        Get-MyITProcessReviews -page 2 -pageSize 50

        Returns results 50 at a time and outputs data from page 2

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Reviews/Get-MyITProcessReviews.html

#>

    [CmdletBinding(DefaultParameterSetName = 'indexByReviews')]
    [alias("Get-MipReviews")]
    Param (
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [switch]$overdue_Reviews,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateSet(   'id', 'name', 'status', 'assignedEngineer.id', 'assignedEngineer.fullName', 'assignedVCIO.id', 'assignedVCIO.fullName',
                        'createdDate', 'lastUpdatedDate', 'client.id', 'client.name' )]
        [string]$filter_field,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateSet( 'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains' )]
        [string]$filter_predicate,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateNotNullOrEmpty()]
        [string]$filter_condition,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateSet( 'or', 'and', $null )]
        [AllowNull()]
        [string]$filter_operator,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateSet(   'id', 'name', 'status', 'assignedEngineer.id', 'assignedEngineer.fullName', 'assignedVCIO.id', 'assignedVCIO.fullName',
                        'createdDate', 'lastUpdatedDate', 'client.id', 'client.name' )]
        [string]$sort_field,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateSet( 'asc', 'desc' )]
        [string]$sort_direction,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [ValidateRange(1,100)]
        [int64]$pageSize,

        [Parameter( Mandatory = $false, ParameterSetName = 'indexByReviews' )]
        [Parameter( Mandatory = $false, ParameterSetName = 'indexByOverdueReviews' )]
        [switch]$allPages
    )

    begin {

        switch ($PSCmdlet.ParameterSetName) {
            'indexByReviews'        { $resource_uri = '/reviews' }
            'indexByOverdueReviews' { $resource_uri = '/reviews/categories/overdue' }
        }

    }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 100 }

        Set-Variable -Name 'MyITProcess_reviewsParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-MyITProcessRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}