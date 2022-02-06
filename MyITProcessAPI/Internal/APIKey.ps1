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
        Add-MyITProcessAPIKey -Api_key 'your_api_key'

        The MyITProcess API will use the string entered into the [ -Api_Key ] parameter.

    .EXAMPLE
        '123==' | Add-MyITProcessAPIKey

        The Add-MyITProcessAPIKey function will use the string passed into it as its API key.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html

#>

    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [AllowEmptyString()]
        [Alias('ApiKey')]
        [string]$Api_Key
    )

    if ($Api_Key) {
        $x_api_key = ConvertTo-SecureString $Api_Key -AsPlainText -Force

        Set-Variable -Name "MyITProcess_API_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
    else {
        Write-Host "Please enter your API key:"
        $x_api_key = Read-Host -AsSecureString

        Set-Variable -Name "MyITProcess_API_Key" -Value $x_api_key -Option ReadOnly -Scope global -Force
    }
}

function Get-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Gets the MyITProcess API key global variable.

    .DESCRIPTION
        The Get-MyITProcessAPIKey cmdlet gets the MyITProcess API key global variable and
        returns it as a SecureString.

    .EXAMPLE
        Get-MyITProcessAPIKey

        Gets the MyITProcess API key global variable and returns it as a SecureString.

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html
#>

    [cmdletbinding()]
    Param ()

    if ($MyITProcess_API_Key){
        $MyITProcess_API_Key
    }
    Else{
        Write-Host "The MyITProcess API key is not set. Run Add-MyITProcessAPIKey to set the API key." -ForegroundColor Yellow
    }
}

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
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html
#>

    [cmdletbinding()]
    Param ()

    if ($MyITProcess_API_Key) {
        Remove-Variable -Name "MyITProcess_API_Key" -Scope global -Force
    }
    Else{
        Write-Host "The MyITProcess API key variable is not set. Nothing to remove" -ForegroundColor Yellow
    }
}

function Test-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Test the MyITProcess API key.

    .DESCRIPTION
        The Test-MyITProcessAPIKey cmdlet tests the base URI & API key that was defined in the
        Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

    .PARAMETER base_uri
        Define the base URI for the MyITProcess API connection using MyITProcess's URI or a custom URI.

        The default base URI is https://reporting.live.myitprocess.com/api/v1

    .EXAMPLE
        Test-MyITProcessBaseURI

        Tests the base URI & API key that was defined in the
        Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

        The default full base uri test path is:
            https://reporting.live.myitprocess.com/api/v1/clients

    .EXAMPLE
        Test-MyITProcessBaseURI -base_uri http://myapi.gateway.example.com

        Tests the base URI & API key that was defined in the
        Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

        The full base uri test path in this example is:
            http://myapi.gateway.example.com/clients

    .NOTES
        N\A

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper
        https://reporting.live.myitprocess.com/index.html
#>

    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = $MyITProcess_Base_URI
    )

    try {
        $resource_uri = '/clients'

        $MyITProcess_Headers.Add('mitp-api-key', (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'N/A', $MyITProcess_API_Key).GetNetworkCredential().Password)
        $rest_output = Invoke-WebRequest -method 'GET' -uri ($base_uri + $resource_uri) -headers $MyITProcess_Headers -ErrorAction Stop
    }
    catch {

        [pscustomobject]@{
            Method = $_.Exception.Response.Method
            StatusCode = $_.Exception.Response.StatusCode.value__
            StatusDescription = $_.Exception.Response.StatusDescription
            Message = $_.Exception.Message
            URI = $($MyITProcess_Base_URI + $resource_uri)
        }

    } finally {
        [void] ($MyITProcess_Headers.Remove('mitp-api-key'))
    }

    if ($rest_output){
        $data = @{}
        $data = $rest_output

        [pscustomobject]@{
            StatusCode = $data.StatusCode
            StatusDescription = $data.StatusDescription
            URI = $($MyITProcess_Base_URI + $resource_uri)
        }
    }
}


New-Alias -Name Set-MyITProcessAPIKey -Value Add-MyITProcessAPIKey -Force
