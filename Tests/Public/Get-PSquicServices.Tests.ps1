BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Get-PSquicServices' {
    BeforeEach {
        # Mock the private function
        Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
            return @{
                serviceIds = @('service123', 'service456', 'service789')
            }
        }
    }

    Context 'When API key is not set' {
        BeforeEach {
            InModuleScope 'PSquic' {
                $script:ApiKey = $null
            }
        }

        It 'should throw an error about missing API key' {
            Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
                throw "API key not set. Please run Connect-PSquic first."
            }

            { Get-PSquicServices } | Should -Throw "*API key not set*"
        }
    }

    Context 'When API key is set' {
        BeforeEach {
            InModuleScope 'PSquic' {
                $script:ApiKey = 'test-api-key'
            }
        }

        It 'should call the correct API endpoint' {
            Get-PSquicServices
            
            Should -Invoke Invoke-PSquicRestMethod -ModuleName 'PSquic' -Times 1 -ParameterFilter {
                $Uri -eq 'https://api.quic.nz/v1/services' -and $Method -eq 'GET'
            }
        }

        It 'should return an array of service IDs' {
            $result = Get-PSquicServices
            
            $result | Should -Be @('service123', 'service456', 'service789')
        }

        It 'should handle API errors gracefully' {
            Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
                throw "HTTP 403: Forbidden"
            }

            { Get-PSquicServices } | Should -Throw "HTTP 403: Forbidden"
        }
    }
}
