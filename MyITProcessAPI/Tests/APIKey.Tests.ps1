<#
    .SYNOPSIS
        Pester tests for functions in the "APIKey.ps1" file

    .DESCRIPTION
        Pester tests for functions in the APIKey.ps1 file which
        is apart of the MyITProcessAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1

        Runs a pester test against "APIKey.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\APIKey.Tests.ps1 -Output Detailed

        Runs a pester test against "APIKey.Tests.ps1" and outputs detailed test results.

    .NOTES
        Build out more robust, logical, & scalable pester tests.
        Look into BeforeAll as it is not working as expected with this test

    .LINK
        https://github.com/Celerium/MyITProcess-PowerShellWrapper

#>

#Requires -Version 5.0
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }
#Requires -Modules @{ ModuleName='MyITProcessAPI'; ModuleVersion='1.0.0' }

# General variables
    $FullFileName = $MyInvocation.MyCommand.Name
    #$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
    #$ThisFileName = $ThisFile | Split-Path -Leaf


Describe "Testing [ *-MyITProcessAPIKey ] functions with [ $FullFileName ]" {

    Context "[ Add-MyITProcessAPIKey ] testing functions" {

        It "The MyITProcess_API_Key variable should initially be empty or null" {
            $MyITProcess_API_Key | Should -BeNullOrEmpty
        }

        It "[ Add-MyITProcessAPIKey ] should accept a value from the pipeline" {
            "MITPAPIKEY" | Add-MyITProcessAPIKey
            Get-MyITProcessAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Add-MyITProcessAPIKey ] called with parameter -API_Key should not be empty" {
            Add-MyITProcessAPIKey -Api_Key "MITPAPIKEY"
            Get-MyITProcessAPIKey | Should -Not -BeNullOrEmpty
        }
    }

    Context "[ Get-MyITProcessAPIKey ] testing functions" {

        It "[ Get-MyITProcessAPIKey ] should return a value" {
            Get-MyITProcessAPIKey | Should -Not -BeNullOrEmpty
        }

        It "[ Get-MyITProcessAPIKey ] should be a SecureString (From PipeLine)" {
            "MITPAPIKEY" | Add-MyITProcessAPIKey
            Get-MyITProcessAPIKey | Should -BeOfType SecureString
        }

        It "[ Get-MyITProcessAPIKey ] should be a SecureString (With Parameter)" {
            Add-MyITProcessAPIKey -Api_Key "MITPAPIKEY"
            Get-MyITProcessAPIKey | Should -BeOfType SecureString
        }
    }

    Context "[ Remove-MyITProcessAPIKey ] testing functions" {

        It "[ Remove-MyITProcessAPIKey ] should remove the MyITProcess_API_Key variable" {
            Add-MyITProcessAPIKey -Api_Key "MITPAPIKEY"
            Remove-MyITProcessAPIKey
            $MyITProcess_API_Key | Should -BeNullOrEmpty
        }
    }

    Context "[ Test-MyITProcessAPIKey ] testing functions" {

        It "[ Test-MyITProcessAPIKey ] without an API key should fail to authenticate" {
            Add-MyITProcessAPIKey -Api_Key "MITPAPIKEY"
            Remove-MyITProcessAPIKey
            $Value = Test-MyITProcessAPIKey
            $Value.Message | Should -BeLike '*"password" is null*'
        }
    }

}