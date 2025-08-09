BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Invoke-PSquicRestMethod' {
    Context 'when API key is not set' {
        BeforeEach {
            # Clear the ApiKey variable before each test in the module scope
            InModuleScope 'PSquic' {
                $script:ApiKey = $null
            }
        }
        
        It 'should throw an error when API key is not set' {
            InModuleScope 'PSquic' {
                { Invoke-PSquicRestMethod -Uri 'https://api.example.com' } | Should -Throw 'API key not set. Please run Connect-PSquic first.'
            }
        }
    }

    Context 'when API key is set' {
        BeforeEach {
            Connect-PSquic -ApiKey 'test-api-key'
            
            # Mock Invoke-RestMethod to avoid actual HTTP calls
            Mock Invoke-RestMethod { 
                return @{ result = 'mocked' }
            } -ModuleName 'PSquic'
        }

        It 'should call Invoke-RestMethod with correct URI and X-API-Key header' {
            InModuleScope 'PSquic' {
                Invoke-PSquicRestMethod -Uri 'https://api.quic.nz/v1/test'
            }
            
            Should -Invoke Invoke-RestMethod -ModuleName 'PSquic' -Times 1 -ParameterFilter {
                $Uri -eq 'https://api.quic.nz/v1/test' -and
                $Method -eq 'GET' -and
                $Headers.'X-API-Key' -eq 'test-api-key'
            }
        }

        It 'should support POST method with body' {
            $testBody = @{ test = 'data' } | ConvertTo-Json

            InModuleScope 'PSquic' {
                param($body)
                Invoke-PSquicRestMethod -Uri 'https://api.quic.nz/v1/test' -Method 'POST' -Body $body
            } -ArgumentList $testBody
            
            Should -Invoke Invoke-RestMethod -ModuleName 'PSquic' -Times 1 -ParameterFilter {
                $Uri -eq 'https://api.quic.nz/v1/test' -and
                $Method -eq 'POST' -and
                $Headers.'X-API-Key' -eq 'test-api-key' -and
                $Body -eq $testBody -and
                $ContentType -eq 'application/json'
            }
        }

        It 'should return the response from Invoke-RestMethod' {
            Mock Invoke-RestMethod { 
                return @{ serviceIds = @('service1', 'service2') }
            } -ModuleName 'PSquic'

            $result = InModuleScope 'PSquic' {
                Invoke-PSquicRestMethod -Uri 'https://api.quic.nz/v1/services'
            }
            
            $result.serviceIds | Should -Be @('service1', 'service2')
        }
    }
}
