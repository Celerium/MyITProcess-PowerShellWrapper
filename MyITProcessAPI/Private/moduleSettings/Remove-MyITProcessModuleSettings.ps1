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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Remove-MyITProcessModuleSettings.html
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