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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessBaseURI.html
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