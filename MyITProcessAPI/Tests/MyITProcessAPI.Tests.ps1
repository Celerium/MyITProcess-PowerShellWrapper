#Requires -Modules Pester

Describe "[ Module Tests ]" {

    BeforeAll {

        # Obtain name of this module by parsing name of test file (MyITProcessAPI\Tests\MyITProcessAPI.Tests.ps1)
        $ThisModule = $PSCommandPath -replace '\.Tests\.ps1$'
        $ThisModuleName = $ThisModule | Split-Path -Leaf

        # Obtain path of the module based on location of test file (MyITProcessAPI\Tests\MyITProcessAPI.Tests.ps1)
        $ThisModulePath = Split-Path (Split-Path -Parent $PSCommandPath) -Parent

        # Make sure one or multiple versions of the module are not loaded
        Get-Module -Name $ThisModuleName | Remove-Module

        # Credit - borrowed with care from http://www.lazywinadmin.com/2016/05/using-pester-to-test-your-manifest-file.html and modified as needed
        # Manifest file path
        $ManifestFile = "$ThisModulePath\$ThisModuleName.psd1"

        # Import the module and store the information about the module
        $ModuleInformation = Import-module -Name $ManifestFile -PassThru

        # Internal Files
        $InternalDirectoryFiles = (
            'APIKey.ps1',
            'BaseURI.ps1',
            'ModuleSettings.ps1'
        )

        # Resource Files
        $ResourceDirectoryFiles = (
            'Clients.ps1',
            'Findings.ps1',
            'Initiatives.ps1',
            'Meetings.ps1',
            'Recommendations.ps1',
            'Reviews.ps1',
            'Users.ps1'
        )

        # Manifest Elements
        $ManifestFileElements = (
            'RootModule',
            'Author',
            'CompanyName',
            'Description',
            'Copyright',
            'PowerShellVersion',
            'NestedModules',
            'HelpInfoURI'
        )
    }

    Context "Test $ThisModuleName Module" {
        It "has the root module $ThisModuleName.psm1" {
            $($ThisModulePath+"\"+$ThisModuleName.psm1) | Should -Exist
        }

        Context "Test Manifest File (.psd1)"{
            It "Should pass Test-ModuleManifest" {
                $errors = $null
                $errors = Test-ModuleManifest -Path $ManifestFile -ErrorAction Stop
                $errors.Count | Should -Be 1
            }

            # Credit - borrowed with care from http://www.lazywinadmin.com/2016/05/using-pester-to-test-your-manifest-file.html and modified as needed
            ForEach ($ManifestFileElement in $ManifestFileElements) {
                It "Should contains $ManifestFileElement"{
                    $ModuleInformation.$ManifestFileElement | Should -Not BeNullOrEmpty
                }
            }
        }

        It "$ThisModuleName\Resources directory has functions" {
            "$ThisModulePath\Resources\*.ps1" | Should -Exist
        }

        # TODO - Only checking one file currently
        It "$ThisModuleName is valid PowerShell code" {
            $psFile = Get-Content -Path "$ThisModulePath\$ThisModuleName.psm1" -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($psfile, [ref]$errors)
            $errors.Count | Should -Be 0
        }
    }

    # Check that Internal files exist
    ForEach ($InternalFile in $InternalDirectoryFiles) {
        Context "Test $InternalFile Internal File in .\Internal directory" {
            It "$InternalFile should exist" {
                "$ThisModulePath\Internal\$InternalFile" | Should -Exist
            }
            It "$InternalFile is valid PowerShell code" {
                $psFile = Get-Content -Path "$ThisModulePath\Internal\$InternalFile" -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psfile, [ref]$errors)
                $errors.Count | Should -Be 0
            }
            # Test for test files
            $InternalFileTest = $InternalFile -replace '\.ps1$'
            It "$InternalFileTest.Tests.ps1 should exist" {
                "$InternalFileTest.Tests.ps1" | Should -Exist
            }
        }
    }

    # Check that Resource files exist
    ForEach ($ResourceFile in $ResourceDirectoryFiles) {
        Context "Test $ResourceFile Resource File in .\Resources directory" {
            It "$ResourceFile should exist" {
                "$ThisModulePath\Resources\$ResourceFile" | Should -Exist
            }
            It "$ResourceFile is valid PowerShell code" {
                $psFile = Get-Content -Path "$ThisModulePath\Resources\$ResourceFile" -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psfile, [ref]$errors)
                $errors.Count | Should -Be 0
            }
        }
        # TODO - add tests to check for tests files
    }

    Context "PowerShell $ThisModuleName Import Test" {
        # Credit - borrowed with care from https://github.com/TheMattCollins0/MattTools/blob/master/Tests/ModuleImport.Tests.ps1 and modified as needed
        It "Should import PowerShell $ThisModuleName successfully" {
            Import-Module -Name $ThisModulePath -ErrorVariable ImportError
            $ImportError | Should -Be $null
        }
    }
}