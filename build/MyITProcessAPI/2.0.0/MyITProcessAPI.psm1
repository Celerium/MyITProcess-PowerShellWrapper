#Region '.\Private\apiCalls\ConvertTo-MyITProcessQueryString.ps1' 0
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
#EndRegion '.\Private\apiCalls\ConvertTo-MyITProcessQueryString.ps1' 152
#Region '.\Private\apiCalls\Invoke-MyITProcessRequest.ps1' 0
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
#EndRegion '.\Private\apiCalls\Invoke-MyITProcessRequest.ps1' 196
#Region '.\Private\apiKeys\Add-MyITProcessAPIKey.ps1' 0
function Add-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls.

    .DESCRIPTION
        The Add-MyITProcessAPIKey cmdlet sets your API key which is used to authenticate all API calls made to MyITProcess.
        Once the API key is defined by Add-MyITProcessAPIKey, it is encrypted using SecureString.

        The MyITProcess API keys are generated via the MyITProcess web interface at Organization Settings > API Keys.

    .PARAMETER Api_Key
        Define your API key that was generated from MyITProcess.

    .EXAMPLE
        Add-MyITProcessAPIKey

        Prompts to enter in the API Key

    .EXAMPLE
        Add-MyITProcessAPIKey -Api_key '12345'

        The MyITProcess API will use the string entered into the [ -Api_Key ] parameter.

    .EXAMPLE
        '12345' | Add-MyITProcessAPIKey

        The Add-MyITProcessAPIKey function will use the string passed into it as its API key.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Add-MyITProcessAPIKey.html

#>

    [CmdletBinding()]
    [alias( 'Add-MipAPIKey', 'Set-MipAPIKey', 'Set-MyITProcessAPIKey' )]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    begin {}

    process {

        if ($Api_Key) {
            $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

            Set-Variable -Name 'MyITProcess_API_Key' -Value $x_api_key -Option ReadOnly -Scope global -Force
        }
        else {
            $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

            Set-Variable -Name 'MyITProcess_API_Key' -Value $x_api_key -Option ReadOnly -Scope Global -Force
        }

    }

    end {}

}
#EndRegion '.\Private\apiKeys\Add-MyITProcessAPIKey.ps1' 67
#Region '.\Private\apiKeys\Get-MyITProcessAPIKey.ps1' 0
function Get-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Gets the MyITProcess API key global variable.

    .DESCRIPTION
        The Get-MyITProcessAPIKey cmdlet gets the MyITProcess API key global variable and
        returns it as a SecureString.

    .PARAMETER plainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-MyITProcessAPIKey

        Gets the MyITProcess API key global variable and returns it as a SecureString.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Get-MyITProcessAPIKey.html
#>

    [CmdletBinding()]
    [alias("Get-MipAPIKey")]
    Param (
        [Parameter( Mandatory = $false) ]
        [Switch]$plainText
    )

    begin {}

    process {

        try {

            if ($MyITProcess_API_Key){
                if ($PlainText){
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($MyITProcess_API_Key)
                    ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                }
                else{$MyITProcess_API_Key}
            }
            else{
                Write-Warning 'The MyITProcess API key is not set. Run Add-MyITProcessAPIKey to set the API key.'
            }
        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }

    }

    end {}

}
#EndRegion '.\Private\apiKeys\Get-MyITProcessAPIKey.ps1' 63
#Region '.\Private\apiKeys\Remove-MyITProcessAPIKey.ps1' 0
function Remove-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Removes the MyITProcess API key global variable.

    .DESCRIPTION
        The Remove-MyITProcessAPIKey cmdlet removes the MyITProcess API key global variable.

    .EXAMPLE
        Remove-MyITProcessAPIKey

        Removes the MyITProcess API key global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Remove-MyITProcessAPIKey.html
#>

    [CmdletBinding(SupportsShouldProcess)]
    [alias("Remove-MipAPIKey")]
    Param ()

    begin {}

    process{

        if ($MyITProcess_API_Key) {
            Remove-Variable -Name 'MyITProcess_API_Key' -Scope Global -Force
        }
        else{
            Write-Warning "The MyITProcess API key variable is not set. Nothing to remove"
        }

    }

    end{}

}
#EndRegion '.\Private\apiKeys\Remove-MyITProcessAPIKey.ps1' 41
#Region '.\Private\apiKeys\Test-MyITProcessAPIKey.ps1' 0
function Test-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Test the MyITProcess API key.

    .DESCRIPTION
        The Test-MyITProcessAPIKey cmdlet tests the base URI & API key that was defined in the
        Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

        This functions validates authorization to the /users endpoint

    .PARAMETER base_uri
        Define the base URI for the MyITProcess API connection using MyITProcess's URI or a custom URI.

        The default base URI is https://reporting.live.myitprocess.com/api/v1

    .EXAMPLE
        Test-MyITProcessBaseURI

        Tests the base URI & API key that was defined in the
        Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

        The default full base uri test path is:
            https://reporting.live.myitprocess.com/api/v1/clients

    .EXAMPLE
        Test-MyITProcessBaseURI -base_uri http://myapi.gateway.example.com

        Tests the base URI & API key that was defined in the
        Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/clients

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Test-MyITProcessAPIKey.html
#>

    [CmdletBinding()]
    [alias("Test-MipAPIKey")]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = $MyITProcess_Base_URI
    )

    begin { $resource_uri = "/users" }

    process {

        Write-Verbose "Testing API key against [ $($base_uri + $resource_uri) ]"

        try {

            $Api_Token = Get-MyITProcessAPIKey -PlainText

            $MyITProcess_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $MyITProcess_Headers.Add('mitp-api-key', $Api_Token)

            $rest_output = Invoke-WebRequest -Method Get -Uri ($base_uri + $resource_uri) -Headers $MyITProcess_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($base_uri + $resource_uri)
            }

        } finally {
            Remove-Variable -Name MyITProcess_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode = $data.StatusCode
                StatusDescription = $data.StatusDescription
                URI = $($base_uri + $resource_uri)
            }
        }

    }

    end {}

}
#EndRegion '.\Private\apiKeys\Test-MyITProcessAPIKey.ps1' 94
#Region '.\Private\baseUri\Add-MyITProcessBaseURI.ps1' 0
function Add-MyITProcessBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the MyITProcess API connection.

    .DESCRIPTION
        The Add-MyITProcessBaseURI cmdlet sets the base URI which is later used to construct the full URI for all API calls.

    .PARAMETER base_uri
        Define the base URI for the MyITProcess API connection using MyITProcess's URI or a custom URI.

    .PARAMETER data_center
        MyITProcess's URI connection point that can be one of the predefined data centers. The accepted values for this parameter are:
        [ US ]
        US = https://reporting.live.myitprocess.com/public-api/v1

    .EXAMPLE
        Add-MyITProcessBaseURI

        The base URI will use https://reporting.live.myitprocess.com/public-api/v1 which is MyITProcess's default URI.

    .EXAMPLE
        Add-MyITProcessBaseURI -data_center US

        The base URI will use https://reporting.live.myitprocess.com/public-api/v1 which is MyITProcess's default URI.

    .EXAMPLE
        Add-MyITProcessBaseURI -base_uri http://myapi.gateway.example.com

        A custom API gateway of http://myapi.gateway.example.com will be used for all API calls to MyITProcess's reporting API.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Add-MyITProcessBaseURI.html
#>

    [CmdletBinding()]
    [alias( "Add-MipBaseURI", "Set-MipBaseURI", "Set-MyITProcessBaseURI" )]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$base_uri = 'https://reporting.live.myitprocess.com/public-api/v1',

        [Parameter( Mandatory = $false) ]
        [ValidateSet( 'US' )]
        [string]$data_center
    )

    begin {}

    process{

        # Trim superfluous forward slash from address (if applicable)
        if ($base_uri[$base_uri.Length-1] -eq "/") {
            $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
        }

        switch ($data_center) {
            'US' { $base_uri = 'https://reporting.live.myitprocess.com/public-api/v1' }
            Default {}
        }

        Set-Variable -Name 'MyITProcess_Base_URI' -Value $base_uri -Option ReadOnly -Scope Global -Force

    }

    end {}

}
#EndRegion '.\Private\baseUri\Add-MyITProcessBaseURI.ps1' 71
#Region '.\Private\baseUri\Get-MyITProcessBaseURI.ps1' 0
function Get-MyITProcessBaseURI {
<#
    .SYNOPSIS
        Shows the MyITProcess base URI global variable.

    .DESCRIPTION
        The Get-MyITProcessBaseURI cmdlet shows the MyITProcess base URI global variable value.

    .EXAMPLE
        Get-MyITProcessBaseURI

        Shows the MyITProcess base URI global variable value.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Get-MyITProcessBaseURI.html
#>

    [CmdletBinding()]
    [alias("Get-MipBaseURI")]
    Param ()

    begin {}

    process {

        switch ([bool]$MyITProcess_Base_URI) {
            $true   { $MyITProcess_Base_URI }
            $false  { Write-Warning "The MyITProcess base URI is not set. Run Add-MyITProcessBaseURI to set the base URI." }
        }

    }

    end {}

}
#EndRegion '.\Private\baseUri\Get-MyITProcessBaseURI.ps1' 39
#Region '.\Private\baseUri\Remove-MyITProcessBaseURI.ps1' 0
function Remove-MyITProcessBaseURI {
<#
    .SYNOPSIS
        Removes the MyITProcess base URI global variable.

    .DESCRIPTION
        The Remove-MyITProcessBaseURI cmdlet removes the MyITProcess base URI global variable.

    .EXAMPLE
        Remove-MyITProcessBaseURI

        Removes the MyITProcess base URI global variable.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Remove-MyITProcessBaseURI.html
#>

    [CmdletBinding(SupportsShouldProcess)]
    [alias("Remove-MipBaseURI")]
    Param ()

    begin {}

    process {

        switch ([bool]$MyITProcess_Base_URI) {
            $true   { Remove-Variable -Name "MyITProcess_Base_URI" -Scope Global -Force }
            $false  { Write-Warning "The MyITProcess base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}
#EndRegion '.\Private\baseUri\Remove-MyITProcessBaseURI.ps1' 39
#Region '.\Private\moduleSettings\Export-MyITProcessModuleSettings.ps1' 0
function Export-MyITProcessModuleSettings {
<#
    .SYNOPSIS
        Exports the MyITProcess BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-MyITProcessModuleSettings cmdlet exports the MyITProcess BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER MyITProcessConfPath
        Define the location to store the MyITProcess configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MyITProcessConfFile
        Define the name of the MyITProcess configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-MyITProcessModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's MyITProcess configuration file located at:
            $env:USERPROFILE\MyITProcessAPI\config.psd1

    .EXAMPLE
        Export-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -MyITProcessConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's MyITProcess configuration file located at:
            C:\MyITProcessAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Export-MyITProcessModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    [alias("Export-MipModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$MyITProcessConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"MyITProcessAPI"}else{".MyITProcessAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$MyITProcessConfFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $MyITProcessConfig = Join-Path -Path $MyITProcessConfPath -ChildPath $MyITProcessConfFile

        # Confirm variables exist and are not null before exporting
        if ($MyITProcess_Base_URI -and $MyITProcess_API_Key -and $MyITProcess_JSON_Conversion_Depth) {
            $secureString = $MyITProcess_API_KEY | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $MyITProcessConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $MyITProcessConfPath -ItemType Directory -Force
            }
@"
    @{
        MyITProcess_Base_URI = '$MyITProcess_Base_URI'
        MyITProcess_API_Key = '$secureString'
        MyITProcess_JSON_Conversion_Depth = '$MyITProcess_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $MyITProcessConfig -Force
        }
        else {
            Write-Error "Failed to export MyITProcess module settings to [ $MyITProcessConfPath\$MyITProcessConfFile ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Export-MyITProcessModuleSettings.ps1' 94
#Region '.\Private\moduleSettings\Get-MyITProcessModuleSettings.ps1' 0
function Get-MyITProcessModuleSettings {
<#
    .SYNOPSIS
        Gets the saved MyITProcess configuration settings

    .DESCRIPTION
        The Get-MyITProcessModuleSettings cmdlet gets the saved MyITProcess configuration settings

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MyITProcessConfPath
        Define the location to store the MyITProcess configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MyITProcessConfFile
        Define the name of the MyITProcess configuration file.

        By default the configuration file is named:
            config.psd1

    .PARAMETER openConfFile
        Opens the MyITProcess configuration file

    .EXAMPLE
        Get-MyITProcessModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-MyITProcessModuleSettings

        The default location of the MyITProcess configuration file is:
            $env:USERPROFILE\MyITProcessAPI\config.psd1

    .EXAMPLE
        Get-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -MyITProcessConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the MyITProcess configuration file in this example is:
            C:\MyITProcessAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Get-MyITProcessModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    [alias("Export-MipModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$MyITProcessConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"MyITProcessAPI"}else{".MyITProcessAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [String]$MyITProcessConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [Switch]$openConfFile
    )

    begin{
        $MyITProcessConfig = Join-Path -Path $MyITProcessConfPath -ChildPath $MyITProcessConfFile
    }

    process{

        if ( Test-Path -Path $MyITProcessConfig ) {

            if($openConfFile){
                Invoke-Item -Path $MyITProcessConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $MyITProcessConfPath -FileName $MyITProcessConfFile
            }

        }
        else {
            Write-Verbose "No configuration file found at [ $MyITProcessConfig ]"
        }

    }

    end{}

}
#EndRegion '.\Private\moduleSettings\Get-MyITProcessModuleSettings.ps1' 89
#Region '.\Private\moduleSettings\Import-MyITProcessModuleSettings.ps1' 0
function Import-MyITProcessModuleSettings {
<#
    .SYNOPSIS
        Imports the MyITProcess BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-MyITProcessModuleSettings cmdlet imports the MyITProcess BaseURI, API, & JSON configuration
        information stored in the MyITProcess configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MyITProcessConfPath
        Define the location to store the MyITProcess configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MyITProcessConfFile
        Define the name of the MyITProcess configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-MyITProcessModuleSettings

        Validates that the configuration file created with the Export-MyITProcessModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The default location of the MyITProcess configuration file is:
            $env:USERPROFILE\MyITProcessAPI\config.psd1

    .EXAMPLE
        Import-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -MyITProcessConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-MyITProcessModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the MyITProcess configuration file in this example is:
            C:\MyITProcessAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Import-MyITProcessModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    [alias("Import-MipModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$MyITProcessConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"MyITProcessAPI"}else{".MyITProcessAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$MyITProcessConfFile = 'config.psd1'
    )

    begin {
        $MyITProcessConfig = Join-Path -Path $MyITProcessConfPath -ChildPath $MyITProcessConfFile
    }

    process {

        if ( Test-Path $MyITProcessConfig ) {
            $tmp_config = Import-LocalizedData -BaseDirectory $MyITProcessConfPath -FileName $MyITProcessConfFile

                # Send to function to strip potentially superfluous slash (/)
                Add-MyITProcessBaseURI $tmp_config.MyITProcess_Base_URI

                $tmp_config.MyITProcess_API_key = ConvertTo-SecureString $tmp_config.MyITProcess_API_key

                Set-Variable -Name 'MyITProcess_Base_URI' -Value $tmp_config.MyITProcess_Base_URI -Option ReadOnly -Scope Global -Force

                Set-Variable -Name 'MyITProcess_API_Key' -Value $tmp_config.MyITProcess_API_key -Option ReadOnly -Scope Global -Force

                Set-Variable -Name 'MyITProcess_JSON_Conversion_Depth' -Value $tmp_config.MyITProcess_JSON_Conversion_Depth -Scope Global -Force

            Write-Verbose "The MyITProcessAPI Module configuration loaded successfully from [ $MyITProcessConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $MyITProcessConfig ] run Add-MyITProcessAPIKey & Add-MyITProcessBaseURI to get started."

            Add-MyITProcessBaseURI

            Set-Variable -Name "MyITProcess_Base_URI" -Value $(Get-MyITProcessBaseURI) -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "MyITProcess_JSON_Conversion_Depth" -Value 100 -Scope Global -Force
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Import-MyITProcessModuleSettings.ps1' 99
#Region '.\Private\moduleSettings\Initialize-MyITProcessModuleSettings.ps1' 0
#Used to auto load either baseline settings or saved configurations when the module is imported
Import-MyITProcessModuleSettings -Verbose:$false
#EndRegion '.\Private\moduleSettings\Initialize-MyITProcessModuleSettings.ps1' 3
#Region '.\Private\moduleSettings\Remove-MyITProcessModuleSettings.ps1' 0
function Remove-MyITProcessModuleSettings {
<#
    .SYNOPSIS
        Removes the stored MyITProcess configuration folder.

    .DESCRIPTION
        The Remove-MyITProcessModuleSettings cmdlet removes the MyITProcess folder and its files.
        This cmdlet also has the option to remove sensitive MyITProcess variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MyITProcessConfPath
        Define the location of the MyITProcess configuration folder.

        By default the configuration folder is located at:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER AndVariables
        Define if sensitive MyITProcess variables should be removed as well.

        By default the variables are not removed.

    .EXAMPLE
        Remove-MyITProcessModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does.

        The default location of the MyITProcess configuration folder is:
            $env:USERPROFILE\MyITProcessAPI

    .EXAMPLE
        Remove-MyITProcessModuleSettings -MyITProcessConfPath C:\MyITProcessAPI -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive MyITProcess variables exist then they are removed as well.

        The location of the MyITProcess configuration folder in this example is:
            C:\MyITProcessAPI

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Remove-MyITProcessModuleSettings.html
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    [alias("Remove-MipModuleSettings")]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [string]$MyITProcessConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop'){"MyITProcessAPI"}else{".MyITProcessAPI"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    begin {}

    process {

        if(Test-Path $MyITProcessConfPath)  {

            Remove-Item -Path $MyITProcessConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($AndVariables) {
                Remove-MyITProcessAPIKey
                Remove-MyITProcessBaseURI
            }

            if ($WhatIfPreference -eq $false){

                if (!(Test-Path $MyITProcessConfPath)) {
                    Write-Output "The MyITProcessAPI configuration folder has been removed successfully from [ $MyITProcessConfPath ]"
                }
                else {
                    Write-Error "The MyITProcessAPI configuration folder could not be removed from [ $MyITProcessConfPath ]"
                }

            }

        }
        else {
            Write-Warning "No configuration folder found at [ $MyITProcessConfPath ]"
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Remove-MyITProcessModuleSettings.ps1' 92
#Region '.\Public\Get-MyITProcessClients.ps1' 0
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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Clients/Get-MyITProcessClients.html

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
#EndRegion '.\Public\Get-MyITProcessClients.ps1' 150
#Region '.\Public\Get-MyITProcessFindings.ps1' 0
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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Findings/Get-MyITProcessFindings.html

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
#EndRegion '.\Public\Get-MyITProcessFindings.ps1' 152
#Region '.\Public\Get-MyITProcessInitiatives.ps1' 0
function Get-MyITProcessInitiatives {
<#
    .SYNOPSIS
        List of initiatives

    .DESCRIPTION
        The Get-MyITProcessInitiatives cmdlet gets a list of initiatives

        Initiatives are located under Strategy > Client > Menu > Initiatives

    .PARAMETER filter_field
        Filter by a specific field name

        Allowed values:
            'id', 'client.id', 'client.name', 'title', 'description',
            'isArchived', 'recommendationsIds'

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
            'id', 'client.id', 'client.name', 'title', 'description',
            'isArchived', 'recommendationsIds'

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
        Get-MyITProcessInitiatives

        Returns the first 100 initiatives

    .EXAMPLE
        Get-MyITProcessInitiatives -filter_field client.id -filter_predicate equal -filter_condition '123456789'

        Returns the initiatives whose client.id equals the defined condition

    .EXAMPLE
        Get-MyITProcessInitiatives -sort_field client.id -sort_direction desc

        Returns the first 100 initiatives sorted by client.id in descending order

    .EXAMPLE
        Get-MyITProcessInitiatives -page 2 -pageSize 50

        Returns results 50 at a time and outputs data from page 2

    .NOTES
        N\A
    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Initiatives/Get-MyITProcessInitiatives.html

#>

    [CmdletBinding()]
    [alias("Get-MipInitiatives")]
    Param (
        [Parameter( Mandatory = $false )]
        [ValidateSet( 'id', 'client.id', 'client.name', 'title', 'description', 'isArchived', 'recommendationsIds' )]
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
        [ValidateSet( 'id', 'client.id', 'client.name', 'title', 'description', 'isArchived', 'recommendationsIds' )]
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

    begin { $resource_uri = '/initiatives' }

    process {

        Write-Verbose "[ $($MyInvocation.MyCommand.Name) ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        #Add default PSBoundParameters
        if( -not $PSBoundParameters.ContainsKey('page') )       { $PSBoundParameters.page = 1 }
        if( -not $PSBoundParameters.ContainsKey('pageSize') )   { $PSBoundParameters.pageSize = 100 }

        Set-Variable -Name 'MyITProcess_initiativesParameters' -Value $PSBoundParameters -Scope Global -Force

        Invoke-MyITProcessRequest -method GET -resource_Uri $resource_Uri -uri_Filter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\Get-MyITProcessInitiatives.ps1' 150
#Region '.\Public\Get-MyITProcessMeetings.ps1' 0
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
#EndRegion '.\Public\Get-MyITProcessMeetings.ps1' 153
#Region '.\Public\Get-MyITProcessRecommendations.ps1' 0
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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Recommendations/Get-MyITProcessRecommendations.html

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
#EndRegion '.\Public\Get-MyITProcessRecommendations.ps1' 178
#Region '.\Public\Get-MyITProcessReviews.ps1' 0
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
#EndRegion '.\Public\Get-MyITProcessReviews.ps1' 179
#Region '.\Public\Get-MyITProcessUsers.ps1' 0
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
#EndRegion '.\Public\Get-MyITProcessUsers.ps1' 147
