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