function Get-MyITProcessAPIKey {
<#
    .SYNOPSIS
        Gets the MyITProcess API key global variable.

    .DESCRIPTION
        The Get-MyITProcessAPIKey cmdlet gets the MyITProcess API key global variable and
        returns it as a SecureString.

    .PARAMETER plainText
        Decrypt and return the API key in plain text.

    .EXAMPLE
        Get-MyITProcessAPIKey

        Gets the MyITProcess API key global variable and returns it as a SecureString.

    .NOTES
        N\A

    .LINK
        https://celerium.github.io/MyITProcess-PowerShellWrapper/site/Internal/Get-MyITProcessAPIKey.html
#>

    [CmdletBinding()]
    [alias("Get-MipAPIKey")]
    Param (
        [Parameter( Mandatory = $false) ]
        [Switch]$plainText
    )

    begin {}

    process {

        try {

            if ($MyITProcess_API_Key){
                if ($PlainText){
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($MyITProcess_API_Key)
                    ( [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($Api_Key) ).ToString()
                }
                else{$MyITProcess_API_Key}
            }
            else{
                Write-Warning 'The MyITProcess API key is not set. Run Add-MyITProcessAPIKey to set the API key.'
            }
        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }

    }

    end {}

}