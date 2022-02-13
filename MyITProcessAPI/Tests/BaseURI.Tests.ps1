<#
    .SYNOPSIS
        Pester tests for functions in the "BaseURI.ps1" file

    .DESCRIPTION
        Pester tests for functions in the "BaseURI.ps1" file which
        is apart of the MyITProcessAPI module.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1

        Runs a pester test against "BaseURI.Tests.ps1" and outputs simple test results.

    .EXAMPLE
        Invoke-Pester -Path .\Tests\BaseURI.Tests.ps1 -Output Detailed

        Runs a pester test against "BaseURI.Tests.ps1" and outputs detailed test results.

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


Describe " Testing [ *-MyITProcessBaseURI } functions with [ $FullFileName ]" {

    Context "[ Add-MyITProcessBaseURI ] testing functions" {

        It "[ Add-MyITProcessBaseURI ] without parameter should return a valid URI" {
            Add-MyITProcessBaseURI
            Get-MyITProcessBaseURI | Should -Be 'https://reporting.live.myitprocess.com/public-api/v1'
        }

        It "[ Add-MyITProcessBaseURI ] should accept a value from the pipeline" {
            'https://celerium.org' | Add-MyITProcessBaseURI
            Get-MyITProcessBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-MyITProcessBaseURI ] with parameter -base_uri should return a valid URI" {
            Add-MyITProcessBaseURI -base_uri 'https://celerium.org'
            Get-MyITProcessBaseURI | Should -Be 'https://celerium.org'
        }

        It "[ Add-MyITProcessBaseURI ] with parameter -data_center US should return a valid URI" {
            Add-MyITProcessBaseURI -data_center 'US'
            Get-MyITProcessBaseURI | Should -Be 'https://reporting.live.myitprocess.com/public-api/v1'
        }

        It "[ Add-MyITProcessBaseURI ] a trailing / from a base_uri should be removed" {
            Add-MyITProcessBaseURI -base_uri 'https://celerium.org/'
            Get-MyITProcessBaseURI | Should -Be 'https://celerium.org'
        }
    }

    Context "[ Get-MyITProcessBaseURI ] testing functions" {

        It "[ Get-MyITProcessBaseURI ] should return a valid URI" {
            Add-MyITProcessBaseURI
            Get-MyITProcessBaseURI | Should -Be 'https://reporting.live.myitprocess.com/public-api/v1'
        }

        It "[ Get-MyITProcessBaseURI ] value should be a string" {
            Add-MyITProcessBaseURI
            Get-MyITProcessBaseURI | Should -BeOfType string
        }
    }

    Context "[ Remove-MyITProcessBaseURI ] testing functions" {

        It "[ Remove-MyITProcessBaseURI ] should remove the variable" {
            Add-MyITProcessBaseURI
            Remove-MyITProcessBaseURI
            $MyITProcess_Base_URI | Should -BeNullOrEmpty
        }
    }

}