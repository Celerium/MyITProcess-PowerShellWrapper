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

        Place holder parameter so that in the event TruMethods adds other API connection point's they can be defined here.

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
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = 'https://reporting.live.myitprocess.com/public-api/v1',

        [Alias('locale','dc')]
        [ValidateSet( 'US' )]
        [String]$data_center = ''
    )

    # Trim superfluous forward slash from address (if applicable)
    if ($base_uri[$base_uri.Length-1] -eq "/") {
        $base_uri = $base_uri.Substring(0,$base_uri.Length-1)
    }

    switch ($data_center) {
        'US' { $base_uri = 'https://reporting.live.myitprocess.com/public-api/v1' }
        Default {}
    }

    Set-Variable -Name "MyITProcess_Base_URI" -Value $base_uri -Option ReadOnly -Scope global -Force
}

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
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html
#>

    [cmdletbinding()]
    Param ()

    if ($MyITProcess_Base_URI){
        $MyITProcess_Base_URI
    }
    Else{
        Write-Host "The MyITProcess base URI is not set. Run Add-MyITProcessBaseURI to set the base URI." -ForegroundColor Yellow
    }
}

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
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html
#>

    [cmdletbinding()]
    Param ()

    if ($MyITProcess_Base_URI) {
        Remove-Variable -Name "MyITProcess_Base_URI" -Scope global -Force
    }
    Else{
        Write-Host "The MyITProcess base URI variable is not set. Nothing to remove" -ForegroundColor Yellow
    }
}

New-Alias -Name Set-MyITProcessBaseURI -Value Add-MyITProcessBaseURI