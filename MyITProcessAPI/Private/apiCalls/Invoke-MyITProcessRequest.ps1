function Invoke-MyITProcessRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-MyITProcessRequest cmdlet invokes an API request to MyITProcess API.

        This is an internal function that is used by all public functions

        As of 2023-08 the MyITProcess v1 API only supports GET requests

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER resource_Uri
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uri_Filter
        Used with the internal function [ ConvertTo-MyITProcessQueryString ] to combine
        a functions parameters with the resource_Uri parameter.

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $MyITProcess_Base_URI + $resource_Uri + ConvertTo-MyITProcessQueryString

    .PARAMETER data
        Place holder parameter to use when other methods are supported
        by the MyITProcess v1 API

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use either the page or perPage
        parameters

    .EXAMPLE
        Invoke-MyITProcessRequest -method GET -resource_Uri '/account' -uri_Filter $uri_Filter

        Invoke a rest method against the defined resource using any of the provided parameters

        Example:
            Name                           Value
            ----                           -----
            Method                         GET
            Uri                            https://MyITProcessapi.us1.my.MyITProcess.com/v1/account?accountId=12345&details=True
            Headers                        {Authorization = Bearer 123456789}
            Body


    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Invoke-MyITProcessRequest.html

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('GET')]
        [String]$method = 'GET',

        [Parameter(Mandatory = $true)]
        [String]$resource_Uri,

        [Parameter(Mandatory = $false)]
        [Hashtable]$uri_Filter = $null,

        [Parameter(Mandatory = $false)]
        [Hashtable]$data = $null,

        [Parameter(Mandatory = $false)]
        [Switch]$allPages

    )

    begin {}

    process {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $query_string = ConvertTo-MyITProcessQueryString -uri_Filter $uri_Filter -resource_Uri $resource_Uri

        Set-Variable -Name 'MyITProcess_queryString' -Value $query_string -Scope Global -Force

        if ($null -eq $data) {
            $body = $null
        } else {
            $body = @{'data'= $data} | ConvertTo-Json -Depth $MyITProcess_JSON_Conversion_Depth
        }

        try {
            $Api_Token = Get-MyITProcessAPIKey -PlainText

            $parameters = [ordered] @{
                "Method"    = $method
                "Uri"       = $query_string.Uri
                "Headers"   = @{ 'mitp-api-key' = $Api_Token }
                "Body"      = $body
            }

                if ( $method -ne 'GET' ) {
                    $parameters['ContentType'] = 'application/json; charset=utf-8'
                }

            Set-Variable -Name 'MyITProcess_invokeParameters' -Value $parameters -Scope Global -Force

            if ($allPages){

                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Gathering all items from [ $( $parameters.uri.LocalPath ) ] "

                $page_number = 1
                $all_responseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $parameters['Uri'] = $query_string.Uri -replace 'page=\d+',"page=$page_number"

                    $current_page = Invoke-RestMethod @parameters -ErrorAction Stop

                    Write-Verbose "[ $page_number ] of [ $( [math]::ceiling( $($current_page.totalCount)/$($current_page.pageSize) ) ) ] pages"

                        foreach ($item in $current_page.items){
                            $all_responseData.add($item)
                        }

                    $page_number++

                } while ( [math]::ceiling( $($current_page.totalCount)/$($current_page.pageSize) ) -ne $page_number - 1 -and $current_page.totalCount -ne 0 )

            }
            else{
                Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Gathering items from [ $( $parameters.uri.LocalPath ) ] "

                $api_response = Invoke-RestMethod @parameters -ErrorAction Stop
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ MyITProcess_invokeParameters, MyITProcess_queryString, & MyITProcess_<CmdletName>Parameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*308*' { Write-Error "Invoke-MyITProcessRequest : Permanent Redirect, check assigned region" }
                '*404*' { Write-Error "Invoke-MyITProcessRequest : Uri not found - [ $resource_Uri ]" }
                '*429*' { Write-Error 'Invoke-MyITProcessRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-MyITProcessRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

        }
        finally {

            $Auth = $MyITProcess_invokeParameters['headers']['mitp-api-key']
            $MyITProcess_invokeParameters['headers']['mitp-api-key'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 5) ) + '*******'

        }


        if($allPages){

            #Making output consistent
            if( [string]::IsNullOrEmpty($all_responseData.items) ){
                $api_response = $null
            }
            else{
                $api_response = [PSCustomObject]@{
                    page        = '1'
                    pageSize    = ($all_responseData | Measure-Object).Count
                    totalCount  = $current_page.totalCount
                    items       = $all_responseData
                }
            }

            return $api_response

        }
        else{ return $api_response }

    }

    end {}

}