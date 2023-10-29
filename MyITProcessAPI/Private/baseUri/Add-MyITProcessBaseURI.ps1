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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Add-MyITProcessBaseURI.html
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