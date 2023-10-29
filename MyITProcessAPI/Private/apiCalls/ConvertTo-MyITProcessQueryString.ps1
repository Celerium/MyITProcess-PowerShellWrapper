function ConvertTo-MyITProcessQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-MyITProcessRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-MyITProcessRequest & any public functions that define parameters

    .PARAMETER uri_Filter
        Hashtable of values to combine a functions parameters with
        the resource_Uri parameter.

        This allows for the full uri query to occur

    .PARAMETER resource_Uri
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-MyITProcessQueryString -uri_Filter $uri_Filter -resource_Uri '/account'

        Example: (From public function)
            $uri_Filter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ){
                if( $excludedParameters -contains $Key.Key ){$null}
                else{ $uri_Filter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://MyITProcessapi.us1.my.MyITProcess.com/v1/account?accountId=12345
            2x key = https://MyITProcessapi.us1.my.MyITProcess.com/v1/account?accountId=12345&details=True

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/ConvertTo-MyITProcessQueryString.html

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [hashtable]$uri_Filter,

    [Parameter(Mandatory = $true)]
    [String]$resource_Uri
)

    begin {}

    process {

        if (-not $uri_Filter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages', 'recommendationId', 'overdue_Reviews'

        $convertParameters = 'filter_', 'sort_'

        $query_filterParameters = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $query_sortParameters   = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        $query_paginationRule   = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

        #Region     [ Format query string ]

        ForEach ( $Key in $uri_Filter.GetEnumerator() ){

            $new_KeyName = $null
            foreach ( $convertParameter in $convertParameters ){

                if ( $Key.Key -like "$convertParameter*" ) {
                    $split_KeyName  = $Key.Key -split '_'
                    $new_KeyName    = $split_KeyName[1]
                }

            }

            if ( $excludedParameters -contains $Key.Key ){ $null }
            else{

                if ($new_KeyName){
                    switch -Wildcard ($Key.Key) {
                        'filter_*'  { $query_filterParameters.Add( "`"$new_KeyName`"", "`"$($Key.Value)`"" ) }
                        'sort_*'    { $query_sortParameters.Add(   "`"$new_KeyName`"", "`"$($Key.Value)`"" ) }
                    }
                }
                else{ $query_paginationRule.Add($Key.Key, $Key.Value) }

            }

        }

        #EndRegion  [ Format query string ]

        #Region     [ Create query string ]

        #All parameters
        if ( [string]::IsNullOrEmpty($query_filterParameters) -eq $false -and [string]::IsNullOrEmpty($query_sortParameters) -eq $false ) {

            $queryFilters   = "queryFilters={$( $query_filterParameters.ToString() -replace "=",":" -replace "&","," )}"
            $sortingRules   = "sortingRules={$( $query_sortParameters.ToString() -replace "=",":" -replace "&","," )}"
            $paginationRule = $query_paginationRule.ToString()

                $uri_Query  = $queryFilters + '&' + $sortingRules + '&' + $paginationRule

        }
        #Filter\Page parameters
        elseif ( [string]::IsNullOrEmpty($query_filterParameters) -eq $false -and [string]::IsNullOrEmpty($query_sortParameters) -eq $true ) {

            $queryFilters   = "queryFilters={$( $query_filterParameters.ToString() -replace "=",":" -replace "&","," )}"
            $paginationRule = $query_paginationRule.ToString()

                $uri_Query  = $queryFilters + '&' + $paginationRule

        }
        #Sort\Page parameters
        elseif ( [string]::IsNullOrEmpty($query_filterParameters) -eq $true -and [string]::IsNullOrEmpty($query_sortParameters) -eq $false ) {

            $sortingRules   = "sortingRules={$( $query_sortParameters.ToString() -replace "=",":" -replace "&","," )}"
            $paginationRule = $query_paginationRule.ToString()

                $uri_Query  = $sortingRules + '&' + $paginationRule

        }
        #Page parameters only
        else{
            $paginationRule = $query_paginationRule.ToString()
            $uri_Query      = $paginationRule
        }

        #EndRegion  [ Create query string ]

        # Build the request and load it with the query string.
        $uri_Request        = [System.UriBuilder]($MyITProcess_Base_URI + $resource_Uri)
        $uri_Request.Query  = $uri_Query

        return $uri_Request

    }

    end {}

}