function Test-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Test the MyITProcess API key.

    .DESCRIPTION
        The Test-MyITProcessAPIKey cmdlet tests the base URI & API key that was defined in the
        Add-MyITProcessBaseURI & Add-MyITProcessAPIKey cmdlets.

        This functions validates authorization to the /users endpoint

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
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/internal/Test-MyITProcessAPIKey.html
#>

    [CmdletBinding()]
    [alias("Test-MipAPIKey")]
    Param (
        [parameter(ValueFromPipeline)]
        [string]$base_uri = $MyITProcess_Base_URI
    )

    begin { $resource_uri = "/users" }

    process {

        Write-Verbose "Testing API key against [ $($base_uri + $resource_uri) ]"

        try {

            $Api_Token = Get-MyITProcessAPIKey -PlainText

            $MyITProcess_Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
            $MyITProcess_Headers.Add('mitp-api-key', $Api_Token)

            $rest_output = Invoke-WebRequest -Method Get -Uri ($base_uri + $resource_uri) -Headers $MyITProcess_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                Method = $_.Exception.Response.Method
                StatusCode = $_.Exception.Response.StatusCode.value__
                StatusDescription = $_.Exception.Response.StatusDescription
                Message = $_.Exception.Message
                URI = $($base_uri + $resource_uri)
            }

        } finally {
            Remove-Variable -Name MyITProcess_Headers -Force
        }

        if ($rest_output){
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode = $data.StatusCode
                StatusDescription = $data.StatusDescription
                URI = $($base_uri + $resource_uri)
            }
        }

    }

    end {}

}