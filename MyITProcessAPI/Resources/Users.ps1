function Get-MyITProcessUsers {
<#
    .SYNOPSIS
        Gets users from the MyITProcess reporting API.

    .DESCRIPTION
        The Get-MyITProcessUsers cmdlet gets users from the MyITProcess reporting API.

    .PARAMETER queryFilters
        Switch statement that allows the body of the JSON request to include an array of filter objects.
        You need to include this switch if you use any of the "filter_*" parameters.

        If this statement is defined, while not required you should also define the following parameters as well:
            - filter_field_name
            - filter_field_predicate
            - filter_field_value
            - filter_field_operator

        .PARAMETER filter_field_name
            Filter by a specific field name.
            Filtering by arrays is not supported at this time.

            Acceptable values are:
                'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate'

            The default value is 'firstName'

        .PARAMETER filter_field_predicate
            Filter by a specific field predicate operator.

            Acceptable values are:
                'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains'

            The default value is 'contains'.

        .PARAMETER filter_field_value
            Filter by a value in the specified field.

            This value cannot be empty.

        .PARAMETER filter_field_operator
            Also filter for other values.

            Acceptable values are:
                'and', 'or', $null

            The default value is 'and'

            This parameter is just a placeholder for now as I am unsure how\why
            to add this functionality if multiple are needed.

    .PARAMETER sortingRules
        Switch statement that allows the body of the JSON request to include an array of sorting objects.
        You need to include this switch if you use any of the "sort_*" parameters.

        If this statement is defined, while not required you should also define the following parameters as well:
            - sort_field_name
            - sort_direction

        .PARAMETER sort_field_name
            Sort by a specific field name.
            Sorting by arrays is not supported at this time.

            Acceptable values are:
                'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate'

            The default value is 'firstName'

        .PARAMETER sort_direction
            Sort the specific field name in a certain direction.

            Acceptable values are:
                'asc', 'desc'

            The default value is 'asc'

    .PARAMETER paginationRule
        Switch statement that allows the body of the JSON request to include objects for pagination.
        You need to include this switch if you use any of the "page_*" parameters.

        If this statement is defined, while not required you should also define the following parameters as well:
            - page_number
            - page_size

        .PARAMETER page_number
            Defines the page number to return.

            The default value is 1

        .PARAMETER page_size
            Defines amount of objects to return with each page.

            The maximum page size allowed is 100

            The default value is 100

    .EXAMPLE
        Example Response Body:

            {
                "page": 1,
                "pageSize": 100,
                "totalCount": 1,
                "items": [
                    {
                        "id": "011a1111-11a1-aa11-a1aa-0010111a1100",
                        "firstName": "John",
                        "lastName": "Smith",
                        "roleName": "vCIO",
                        "lastLoginDate": "2019-01-01T00:00:00",
                    }
                ]
            }

    .EXAMPLE
        Get-MyITProcessUsers

        Gets the first 100 users from the MyITProcess reporting API. Data is sorted by firstName and returned in ascending order.

    .EXAMPLE
        Get-MyITProcessUsers -queryFilters -filter_field_name firstName -filter_field_predicate equal -filter_field_value 'John'

        Gets the first 100 users whose firstName equals 'John'. Data is sorted by firstName and returned in ascending order.

    .EXAMPLE
        Get-MyITProcessUsers -sortingRules -sort_field_name id -sort_direction desc

        Gets the first 100 users from the MyITProcess reporting API. Data is sorted by id and returned in descending order.

    .EXAMPLE
        Get-MyITProcessUsers -pagingRule -page_number 2 -page_size 50

        Returns results 50 at a time and outputs data from page 2. Data is sorted by firstName and returned in ascending order.

    .EXAMPLE
        Get-MyITProcessUsers    -queryFilters -filter_field_name firstName -filter_field_predicate equal -filter_field_value 'John'
                                -sortingRules -sort_field_name id -sort_direction desc
                                -pagingRule -page_number 2 -page_size 50

        Gets the first 100 users whose firstName equals 'John' then sorts the results by id in descending order,
        returns results 50 at a time and outputs data from page 2.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html

#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(ParameterSetName = 'index')]
        [switch]$queryFilters,

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate' )]
            [string]$filter_field_name = 'name',

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'equal', 'notEqual', 'greaterThan', 'lessThan', 'contains' )]
            [string]$filter_field_predicate = 'contains',

            [Parameter(ParameterSetName = 'index')]
            [string]$filter_field_value = '',

            [Parameter(ParameterSetName = 'index')] #Unsure how to add this functionality if multiple are needed
            [ValidateSet( 'or', 'and', $null )]
            [AllowNull()]
            [string]$filter_field_operator = 'and',

        [Parameter(ParameterSetName = 'index')]
        [switch]$sortingRules,

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'id', 'firstName', 'lastName', 'roleName', 'lastLoginDate' )]
            [string]$sort_field_name = 'name',

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'asc', 'desc' )]
            [string]$sort_direction = 'asc',

        [Parameter(ParameterSetName = 'index')]
        [switch]$paginationRule,

            [Parameter(ParameterSetName = 'index')]
            [ValidateRange(1, [int]::MaxValue)]
            [Int64]$page_number = '1',

            [Parameter(ParameterSetName = 'index')]
            [ValidateRange(1,100)]
            [int]$page_size = '100'
    )

    $resource_uri = '/users'

    $body = @{}

    if ($PSCmdlet.ParameterSetName -eq 'index') {

        if ($queryFilters) {

            $Parameters = @{
                'field' = $filter_field_name
                'predicate' = $filter_field_predicate
                'condition' = $filter_field_value
                'operator' = $filter_field_operator
            } | ConvertTo-Json

            $body += @{
                'queryFilters' = $Parameters
            }
        }

        if ($sortingRules) {

            $Parameters = @{
                'field' = $sort_field_name
                'direction' = $sort_direction
            } | ConvertTo-Json

            $body += @{
                'sortingRules' = $Parameters
            }
        }
        if ($paginationRule) {
                $body += @{
                    'page' = $page_number
                    'pageSize' = $page_size
                }
        }
    }

    try {
        $MyITProcess_Headers.Add('mitp-api-key', (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'N/A', $MyITProcess_API_Key).GetNetworkCredential().Password)
        $rest_output = Invoke-RestMethod -method 'GET' -uri ($MyITProcess_Base_URI + $resource_uri) -headers $MyITProcess_Headers `
            -body $body -ErrorAction Stop -ErrorVariable web_error
    } catch {
        Write-Error $_
    } finally {
        [void] ($MyITProcess_Headers.Remove('mitp-api-key'))
    }

    $data = @{}
    $data = $rest_output
    return $data

}
