function Export-MyITProcessModuleSettings {
<#
    .SYNOPSIS
        Exports the MyITProcess BaseURI, API, & JSON configuration information to file.

    .DESCRIPTION
        The Export-MyITProcessModuleSettings cmdlet exports the MyITProcess BaseURI, API, & JSON configuration information to file.

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal.
        This means that you cannot copy your configuration file to another computer or user account and expect it to work.

    .PARAMETER MITPAPIConfPath
        Define the location to store the MyITProcess configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MITPAPIConfFile
        Define the name of the MyITProcess configuration file.

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-MyITProcessModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's MyITProcess configuration file located at:
            $env:USERPROFILE\MyITProcessAPI\config.psd1

    .EXAMPLE
        Export-MyITProcessModuleSettings -MITPAPIConfPath C:\MyITProcessAPI -MITPAPIConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's MyITProcess configuration file located at:
            C:\MyITProcessAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html

#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$MITPAPIConfPath = "$($env:USERPROFILE)\MyITProcessAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$MITPAPIConfFile = 'config.psd1'
    )

    # Confirm variables exist and are not null before exporting
    if ($MyITProcess_Base_URI -and $MyITProcess_API_Key -and $MyITProcess_JSON_Conversion_Depth) {
        $secureString = $MyITProcess_API_KEY | ConvertFrom-SecureString
        New-Item -ItemType Directory -Force -Path $MITPAPIConfPath | ForEach-Object {$_.Attributes = 'hidden'}
@"
    @{
        MyITProcess_Base_URI = '$MyITProcess_Base_URI'
        MyITProcess_API_Key = '$secureString'
        MyITProcess_JSON_Conversion_Depth = '$MyITProcess_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath ($MITPAPIConfPath+"\"+$MITPAPIConfFile) -Force
    }
    else {
        Write-Host "Failed export MyITProcess Module settings to [ $MITPAPIConfPath\$MITPAPIConfFile ]" -ForegroundColor Red
    }
}

function Import-MyITProcessModuleSettings {
<#
    .SYNOPSIS
        Imports the MyITProcess BaseURI, API, & JSON configuration information to the current session.

    .DESCRIPTION
        The Import-MyITProcessModuleSettings cmdlet imports the MyITProcess BaseURI, API, & JSON configuration
        information stored in the MyITProcess configuration file to the users current session.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MITPAPIConfPath
        Define the location to store the MyITProcess configuration file.

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MITPAPIConfFile
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
        Import-MyITProcessModuleSettings -MITPAPIConfPath C:\MyITProcessAPI -MITPAPIConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-MyITProcessModuleSettings cmdlet exists
        then imports the stored data into the current users session.

        The location of the MyITProcess configuration file in this example is:
            C:\MyITProcessAPI\MyConfig.psd1

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html

#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$MITPAPIConfPath = "$($env:USERPROFILE)\MyITProcessAPI",

        [Parameter(ParameterSetName = 'set')]
        [string]$MITPAPIConfFile = 'config.psd1'
    )

    if( test-path ($MITPAPIConfPath+"\"+$MITPAPIConfFile) ) {
        $tmp_config = Import-LocalizedData -BaseDirectory $MITPAPIConfPath -FileName $MITPAPIConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-MyITProcessBaseURI $tmp_config.MyITProcess_Base_URI

            $tmp_config.MyITProcess_API_key = ConvertTo-SecureString $tmp_config.MyITProcess_API_key

            Set-Variable -Name "MyITProcess_API_Key"  -Value $tmp_config.MyITProcess_API_key `
                        -Option ReadOnly -Scope global -Force

            Set-Variable -Name "MyITProcess_JSON_Conversion_Depth" -Value $tmp_config.MyITProcess_JSON_Conversion_Depth `
                        -Scope global -Force

        Write-Host "MyITProcessAPI Module configuration loaded successfully from [ $MITPAPIConfPath\$MITPAPIConfFile ]" -ForegroundColor Green

        # Clean things up
        Remove-Variable "tmp_config"
    }
    else {
        Write-Verbose "No configuration file found at [ $MITPAPIConfPath\$MITPAPIConfFile ]"
        Write-Verbose "Please run Add-MyITProcessAPIKey to get started."

            Set-Variable -Name "MyITProcess_Base_URI" -Value "https://reporting.live.myitprocess.com/public-api/v1" -Option ReadOnly -Scope global -Force
            Set-Variable -Name "MyITProcess_JSON_Conversion_Depth" -Value 100 -Scope global -Force
    }
}

function Remove-MyITProcessModuleSettings {
<#
    .SYNOPSIS
        Removes the stored MyITProcess configuration folder.

    .DESCRIPTION
        The Remove-MyITProcessModuleSettings cmdlet removes the MyITProcess folder and its files.
        This cmdlet also has the option to remove sensitive MyITProcess variables as well.

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\MyITProcessAPI

    .PARAMETER MITPAPIConfPath
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
        Remove-MyITProcessModuleSettings -MITPAPIConfPath C:\MyITProcessAPI -AndVariables

        Checks to see if the defined configuration folder exists and removes it if it does.
        If sensitive MyITProcess variables exist then they are removed as well.

        The location of the MyITProcess configuration folder in this example is:
            C:\MyITProcessAPI

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html

#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$MITPAPIConfPath = "$($env:USERPROFILE)\MyITProcessAPI",

        [Parameter(ParameterSetName = 'set')]
        [switch]$AndVariables
    )

    if(Test-Path $MITPAPIConfPath)  {

        Remove-Item -Path $MITPAPIConfPath -Recurse -Force

        If ($AndVariables) {
            if ($MyITProcess_API_Key) {
                Remove-Variable -Name "MyITProcess_API_Key" -Scope global -Force
            }
            if ($MyITProcess_Base_URI) {
                Remove-Variable -Name "MyITProcess_Base_URI" -Scope global -Force
            }
        }

            if (!(Test-Path $MITPAPIConfPath)) {
                Write-Host "The MyITProcessAPI configuration folder has been removed successfully from [ $MITPAPIConfPath ]" -ForegroundColor Green
            }
            else {
                Write-Host "The MyITProcessAPI configuration folder could not be removed from [ $MITPAPIConfPath ]" -ForegroundColor Red
            }

    }
    else {
        Write-Host "No configuration folder found at [ $MITPAPIConfPath ]" -ForegroundColor Yellow
    }
}