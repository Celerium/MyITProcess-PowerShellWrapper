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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessAPIKey.html
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
