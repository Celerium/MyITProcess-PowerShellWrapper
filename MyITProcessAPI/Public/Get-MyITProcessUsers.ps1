function Get-MyITProcessUsers {
<#
    .SYNOPSIS
        List of users

    .DESCRIPTION
        The Get-MyITProcessUsers cmdlet gets a List of users

    .PARAMETER filter_field
        Filter by a specific field name

        Allowed values:
            'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate'

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
            'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate'

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
        Get-MyITProcessUsers

        Returns the first 100 users

    .EXAMPLE
        Get-MyITProcessUsers -filter_field firstName -filter_predicate equal -filter_condition 'Celerium'

        Returns the users whose firstName equals the defined condition

    .EXAMPLE
        Get-MyITProcessUsers -sort_field firstName -sort_direction desc

        Returns the first 100 users sorted by firstName in descending order

    .EXAMPLE
        Get-MyITProcessUsers -page 2 -pageSize 50

        Returns results 50 at a time and outputs data from page 2

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Users/Get-MyITProcessUsers.html

#>

    [CmdletBinding()]
    [alias("Get-MipUsers")]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet( 'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate' )]
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
        [ValidateSet( 'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate' )]
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

    begin { $resource_uri = '/users' }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 100 }

        Set-Variable -Name 'MyITProcess_usersParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-MyITProcessRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
