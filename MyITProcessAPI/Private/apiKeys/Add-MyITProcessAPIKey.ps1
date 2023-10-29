function Add-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Sets your API key used to authenticate all API calls.

    .DESCRIPTION
        The Add-MyITProcessAPIKey cmdlet sets your API key which is used to authenticate all API calls made to MyITProcess.
        Once the API key is defined by Add-MyITProcessAPIKey, it is encrypted using SecureString.

        The MyITProcess API keys are generated via the MyITProcess web interface at Organization Settings > API Keys.

    .PARAMETER Api_Key
        Define your API key that was generated from MyITProcess.

    .EXAMPLE
        Add-MyITProcessAPIKey

        Prompts to enter in the API Key

    .EXAMPLE
        Add-MyITProcessAPIKey -Api_key '12345'

        The MyITProcess API will use the string entered into the [ -Api_Key ] parameter.

    .EXAMPLE
        '12345' | Add-MyITProcessAPIKey

        The Add-MyITProcessAPIKey function will use the string passed into it as its API key.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Add-MyITProcessAPIKey.html

#>

    [CmdletBinding()]
    [alias( 'Add-MipAPIKey', 'Set-MipAPIKey', 'Set-MyITProcessAPIKey' )]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    begin {}

    process {

        if ($Api_Key) {
            $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

            Set-Variable -Name 'MyITProcess_API_Key' -Value $x_api_key -Option ReadOnly -Scope global -Force
        }
        else {
            $x_api_key = Read-Host -Prompt 'Please enter your API key' -AsSecureString

            Set-Variable -Name 'MyITProcess_API_Key' -Value $x_api_key -Option ReadOnly -Scope Global -Force
        }

    }

    end {}

}