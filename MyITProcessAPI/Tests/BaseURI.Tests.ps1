#Requires -Modules Pester

# Obtain name of this file
$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
$ThisFileName = $ThisFile | Split-Path -Leaf

Describe "Tests" {
    Context "Test $ThisFileName Functions" {
        It "Add-MyITProcessBaseURI without parameter should return a valid URI" {
            Add-MyITProcessBaseURI
            $BaseURI = Get-MyITProcessBaseURI
            $BaseURI | Should -Be 'https://reporting.live.myitprocess.com/public-api/v1'
        }
        It "Add-MyITProcessBaseURI parameter US should return a valid URI" {
            Add-MyITProcessBaseURI -data_center 'US'
            $BaseURI = Get-MyITProcessBaseURI
            $BaseURI | Should -Be 'https://reporting.live.myitprocess.com/public-api/v1'
        }
        It "Remove-MyITProcessBaseURI should remove the variable" {
            Remove-MyITProcessBaseURI
            $BaseURI = Get-MyITProcessBaseURI
            $BaseURI | Should -BeNullOrEmpty
        }
    }
}