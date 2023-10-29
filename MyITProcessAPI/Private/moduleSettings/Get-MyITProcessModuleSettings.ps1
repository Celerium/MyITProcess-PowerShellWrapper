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