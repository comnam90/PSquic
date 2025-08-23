BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../Source/PSquic.psd1" -Force
    
    # Mock Invoke-RestMethod at the module level
    Mock Invoke-RestMethod -ModuleName 'PSquic' {
        param($Uri, $Method, $Headers, $Body, $ContentType, $OutFile)
        
        if ($Uri -eq 'https://api.quic.nz/v1/services') {
            return @{
                serviceIds = @('service123', 'service456')
            }
        }
        elseif ($Uri -like 'https://api.quic.nz/v1/session*') {
            return @{
                service = @{
                    username = 'testuser'
                    status = 'active'
                    entity = 'Quic'
                    entityUniqueId = '106511'
                }
                status = 'connected'
                sessionType = 'DHCP'
                activeIPv4Prefix = '192.168.1.100'
                activeIPv4PrefixLength = 32
            }
        }
        elseif ($Uri -eq 'https://api.quic.nz/v1/weathermap') {
            if ($OutFile) {
                # Simulate saving file
                'fake image data' | Out-File $OutFile
                return $null
            }
            else {
                return [byte[]](1..100)
            }
        }
    }
}

Describe 'PSquic Integration Tests' -Tag 'Integration', 'Slow' {
    Context 'Full workflow integration' {        
        It 'should allow complete workflow from connection to data retrieval' {
            # Connect to the API
            Connect-PSquic -ApiKey 'test-api-key'
            
            # Get list of services
            $services = Get-PSquicServices
            $services | Should -Contain 'service123'
            $services | Should -Contain 'service456'
            
            # Get session data for each service
            $sessions = $services | Get-PSquicSession
            $sessions | Should -HaveCount 2
            $sessions[0].status | Should -Be 'connected'
            
            # Get weather map
            $weatherData = Get-PSquicWeatherMap
            $weatherData | Should -BeOfType [byte]
            
            # Verify all API calls were made with correct authentication
            Should -Invoke Invoke-RestMethod -ModuleName 'PSquic' -Exactly 4 -ParameterFilter {
                $Headers.'X-API-Key' -eq 'test-api-key'
            }
        }

        It 'should handle pipeline operations correctly' {
            Connect-PSquic -ApiKey 'test-api-key'
            
            # Test pipeline from services to sessions
            $result = Get-PSquicServices | Get-PSquicSession
            
            $result | Should -HaveCount 2
            $result[0].service.username | Should -Be 'testuser'
        }

        It 'should support complete connect-use-disconnect workflow' {
            # Connect
            Connect-PSquic -ApiKey 'test-api-key'
            
            # Use the API
            $services = Get-PSquicServices
            $services | Should -HaveCount 2
            
            # Disconnect
            Disconnect-PSquic
            
            # Verify disconnection
            { Get-PSquicServices } | Should -Throw "*API key not set*"
        }
    }

    Context 'Error handling' {
        It 'should require connection before using other functions' {
            InModuleScope 'PSquic' {
                $script:ApiKey = $null
            }
            
            { Get-PSquicServices } | Should -Throw "*API key not set*"
            { Get-PSquicSession -ServiceId 'test' } | Should -Throw "*API key not set*"
            { Get-PSquicWeatherMap } | Should -Throw "*API key not set*"
        }
    }
}
