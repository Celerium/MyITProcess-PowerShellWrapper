function Get-MyITProcessClients {
<#
    .SYNOPSIS
        Lists all clients (both active and inactive)

    .DESCRIPTION
        The Get-MyITProcessClients cmdlet lists all clients (both active and inactive)

    .PARAMETER filter_field
        Filter by a specific field name

        Allowed values:
            'id', 'name', 'createdDate', 'isActive', 'deactivatedDate',
            'lastReviewDate', 'lastAssignedMemberActivityDate', 'alignmentScore'

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
            'id', 'name', 'createdDate', 'isActive', 'deactivatedDate',
            'lastReviewDate', 'lastAssignedMemberActivityDate', 'alignmentScore'

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
        Get-MyITProcessClients

        Returns the first 100 clients

    .EXAMPLE
        Get-MyITProcessClients -filter_field name -filter_predicate equal -filter_condition 'Celerium'

        Returns the clients whose name equals the defined condition

    .EXAMPLE
        Get-MyITProcessClients -sort_field name -sort_direction desc

        Returns the first 100 clients sorted by name in descending order

    .EXAMPLE
        Get-MyITProcessClients -page 2 -pageSize 50

        Returns results 50 at a time and outputs data from page 2

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/clients/Get-MyITProcessClients.html

#>

    [CmdletBinding()]
    [alias("Get-MipClients")]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet( 'id', 'name', 'createdDate', 'isActive', 'deactivatedDate', 'lastReviewDate', 'lastAssignedMemberActivityDate', 'alignmentScore' )]
        [string]$filter_field,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains' )]
        [string]$filter_predicate,

        [Parameter( Mandatory = $false )]
        [AllowNull()]
        [string]$filter_condition,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'or', 'and', $null )]
        [AllowNull()]
        [string]$filter_operator,

        [Parameter( Mandatory = $false )]
        [ValidateSet( 'id', 'name', 'createdDate', 'isActive', 'deactivatedDate', 'lastReviewDate', 'lastAssignedMemberActivityDate', 'alignmentScore' )]
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

    begin { $resource_uri = '/clients' }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 100 }

        Set-Variable -Name 'MyITProcess_clientParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-MyITProcessRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
