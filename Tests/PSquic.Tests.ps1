BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../Source/PSquic.psd1" -Force
}

Describe 'PSquic Module' -Tag 'Unit', 'Module' {
    Context 'Module Loading' {
        It 'Should import successfully' {
            Get-Module 'PSquic' | Should -Not -BeNullOrEmpty
        }

        It 'Should export all expected public functions' {
            $expectedFunctions = @(
                'Connect-PSquic',
                'Disconnect-PSquic',
                'Get-PSquicBandwidthUsage',
                'Get-PSquicIPAddress',
                'Get-PSquicNetworkInfo',
                'Get-PSquicServices',
                'Get-PSquicSession',
                'Get-PSquicSessionStatus',
                'Get-PSquicWeatherMap',
                'Test-PSquicSessionExpiry'
            )
            
            $module = Get-Module 'PSquic'
            $exportedFunctions = $module.ExportedFunctions.Keys
            
            foreach ($function in $expectedFunctions) {
                $exportedFunctions | Should -Contain $function
            }
        }

        It 'Should not export private functions' {
            $module = Get-Module 'PSquic'
            $exportedFunctions = $module.ExportedFunctions.Keys
            
            $exportedFunctions | Should -Not -Contain 'Invoke-PSquicRestMethod'
            $exportedFunctions | Should -Not -Contain 'Test-Func'
        }
    }

    Context 'Module Metadata' {
        It 'Should have correct module version format' {
            $module = Get-Module 'PSquic'
            $module.Version | Should -Match '^\d+\.\d+\.\d+$'
        }

        It 'Should have author information' {
            $module = Get-Module 'PSquic'
            $module.Author | Should -Not -BeNullOrEmpty
        }

        It 'Should have description' {
            $module = Get-Module 'PSquic'
            $module.Description | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Module Variables' {
        It 'Should initialize ApiKey variable as null' {
            InModuleScope 'PSquic' {
                $script:ApiKey | Should -BeNullOrEmpty
            }
        }
    }
}
