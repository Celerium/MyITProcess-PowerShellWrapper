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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Export-MyITProcessModuleSettings.html
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