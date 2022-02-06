#Requires -Modules Pester

# Obtain name of this file
$ThisFile = $PSCommandPath -replace '\.Tests\.ps1$'
$ThisFileName = $ThisFile | Split-Path -Leaf

Describe "Tests" {
    Context "Test $ThisFileName Functions" {
        It "MyITProcess_API_Key should initially be empty or null" {
            $MyITProcess_API_Key | Should -BeNullOrEmpty
        }
        It "Add-MyITProcessAPIKey called with parameter MyITProcess_API_Key should not be empty" {
            Add-MyITProcessAPIKey -Api_Key "MITPAPIKEY"
            Get-MyITProcessAPIKey | Should -Not -BeNullOrEmpty
        }
        It "Get-MyITProcessAPIKey should return a value" {
            Get-MyITProcessAPIKey | Should -Not -BeNullOrEmpty
        }
        It "Remove-MyITProcessAPIKey should remove the MyITProcess_API_Key variable" {
            Remove-MyITProcessAPIKey
            Get-MyITProcessAPIKey | Should -BeNullOrEmpty
        }
    }
}