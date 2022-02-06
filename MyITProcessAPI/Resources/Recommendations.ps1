function Get-MyITProcessRecommendations {
<#
    .SYNOPSIS
        Gets recommendations from the MyITProcess reporting API.

    .DESCRIPTION
        The Get-MyITProcessRecommendations cmdlet gets recommendations from the MyITProcess reporting API.

        Meetings are located under the Strategy section in the MyITProcess.
            Strategy > Client > Menu > Recommendation backlog

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
                'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
                'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived'

            The default value is 'name'

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
                'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth',
                'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived'

            The default value is 'name'

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
                        "id": 12345,
                        "parentId": null,
                        "client": {
                            "id": "011a1111-11a1-aa11-a1aa-0010111a1100",
                            "name": "Sample Customer #1"
                        },
                        "initiative": {
                            "id": 123
                        },
                        "name": "Recommendation #1",
                        "description": "This is just a description",
                        "budget": 100000,
                        "budgetMonth": "2015-01",
                        "hours": 100,
                        "type": "Maintenance",
                        "responsibleParty": "Us",
                        "status": "Accepted",
                        "priority": "Medium",
                        "isArchived": false,
                        "recommendationFeedbacks": [
                            {
                                "id": 0,
                                "description": "string",
                                "status": "NotDiscussed",
                                "modifedBy": "011a1111-11a1-aa11-a1aa-0010111a1100",    #Yes this is right, I have let MyITProcess know about this.
                                "modefiedDate": "2019-01-01T00:00:00"                   #Yes this is right, I have let MyITProcess know about this.
                            }
                        ]
                    }
                ]
            }

    .EXAMPLE
        Get-MyITProcessRecommendations

        Gets the first 100 recommendations from the MyITProcess reporting API.

    .EXAMPLE
        Get-MyITProcessRecommendations -queryFilters -filter_field_name name -filter_field_predicate equal -filter_field_value 'Cloud-Migration'

        Gets the recommendations whose name equals 'Cloud-Migration'.

    .EXAMPLE
        Get-MyITProcessRecommendations -sortingRules -sort_field_name id -sort_direction desc

        Gets the first 100 recommendations from the MyITProcess reporting API. Data is sorted by id and returned in descending order.

    .EXAMPLE
        Get-MyITProcessRecommendations -pagingRule -page_number 2 -page_size 50

        Returns results 50 at a time and outputs data from page 2. Data is sorted by name and returned in ascending order.

    .EXAMPLE
        Get-MyITProcessRecommendations -queryFilters -filter_field_name name -filter_field_predicate equal -filter_field_value 'Cloud-Migration' -sortingRules -sort_field_name id -sort_direction desc -pagingRule -page_number 2 -page_size 50

        Gets the recommendations whose name equals 'Cloud-Migration' then sorts the results by id in descending order and returns results 50 at a time and outputs data from page 2.

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
            [ValidateSet(   'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth', `
                            'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived' )]
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
            [ValidateSet(   'id', 'parentId', 'client.id', 'client.name', 'initiative.id', 'name', 'description', 'budget', 'budgetMonth', `
                            'hours', 'type', 'responsibleParty', 'status', 'priority', 'isArchived' )]
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

    $resource_uri = '/recommendations'

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


function Get-MyITProcessRecommendationsConfigurations {
<#
    .SYNOPSIS
        Gets configurations linked to a recommendation from the MyITProcess reporting API.

    .DESCRIPTION
        The Get-MyITProcessRecommendationsConfigurations gets configurations linked
        to a recommendation from the MyITProcess reporting API.

        Configurations are located under the Strategy section in the MyITProcess.
            Strategy > Client > Recommendation > Configurations

    .PARAMETER recommendationId
        Switch statement that allows the body of the JSON request to include an array of filter objects.
        You need to include this switch if you use any of the "filter_*" parameters.

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
                'id', 'name', 'status', 'type', 'location', 'expirationDate'

            The default value is 'name'

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
                'id', 'name', 'status', 'type', 'location', 'expirationDate'

            The default value is 'name'

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
                        "id": 123456789,
                        "name": "Server-001",
                        "status": Active,
                        "type": "Server",
                        "location": "Server Room",
                        "expirationDate": "2020-01-01T00:00:00.000Z"
                    }
                ]
            }

    .EXAMPLE
        Get-MyITProcessRecommendationsConfigurations -recommendationId 123456789

        Gets the first 100 configurations linked to the recommendation with an id of '123456789'

    .EXAMPLE
        Get-MyITProcessRecommendations -recommendationId 123456789 -queryFilters -filter_field_name name -filter_field_predicate equal -filter_field_value 'Server-001'

        Gets a configuration whose name equals 'Server-001' that is linked to the recommendation with an id of '123456789'

    .EXAMPLE
        Get-MyITProcessRecommendations -recommendationId 123456789 -sortingRules -sort_field_name id -sort_direction desc

        Gets the first 100 configurations linked to the recommendation with an id of '123456789' Data is sorted by id and returned in descending order.

    .EXAMPLE
        Get-MyITProcessRecommendations -recommendationId 123456789 -pagingRule -page_number 2 -page_size 50

        Returns results 50 at a time and outputs data from page 2. Data is sorted by name and returned in ascending order.

    .EXAMPLE
        Get-MyITProcessRecommendations  -recommendationId 123456789 `
                                        -queryFilters -filter_field_name type -filter_field_predicate equal -filter_field_value 'Server' `
                                        -sortingRules -sort_field_name id -sort_direction desc `
                                        -pagingRule -page_number 2 -page_size 50

        Gets a configuration whose type equals 'Server' that is linked to the recommendation with an id of '123456789'
        then sorts the results by id in descending order and returns results 50 at a time and outputs data from page 2.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html

#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(ParameterSetName = 'index', Mandatory = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int64]$recommendationId,

        [Parameter(ParameterSetName = 'index')]
        [switch]$queryFilters,

            [Parameter(ParameterSetName = 'index')]
            [ValidateSet( 'id', 'name', 'status', 'type', 'location', 'expirationDate' )]
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
            [ValidateSet( 'id', 'name', 'status', 'type', 'location', 'expirationDate' )]
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

    $resource_uri = "/recommendations/$recommendationId/configurations"

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
