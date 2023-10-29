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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Get-MyITProcessBaseURI.html
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