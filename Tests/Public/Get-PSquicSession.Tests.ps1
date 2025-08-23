BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Get-PSquicSession' -Tag 'Unit', 'Fast' {
    BeforeEach {
        # Mock the private function with sample session data
        Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
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
                activeIPv6Prefix = '2001:db8::'
                activeIPv6PrefixLength = 56
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

            { Get-PSquicSession -ServiceId 'service123' } | Should -Throw "*API key not set*"
        }
    }

    Context 'When API key is set' {
        BeforeEach {
            InModuleScope 'PSquic' {
                $script:ApiKey = 'test-api-key'
            }
        }

        It 'should call the correct API endpoint with service parameter' {
            Get-PSquicSession -ServiceId 'service123'
            
            Should -Invoke Invoke-PSquicRestMethod -ModuleName 'PSquic' -Exactly 1 -ParameterFilter {
                $Uri -eq 'https://api.quic.nz/v1/session?service=service123' -and $Method -eq 'GET'
            }
        }

        It 'should return session data for a valid service' {
            $result = Get-PSquicSession -ServiceId 'service123'
            
            $result.status | Should -Be 'connected'
            $result.sessionType | Should -Be 'DHCP'
            $result.service.username | Should -Be 'testuser'
        }

        It 'should handle API errors gracefully' {
            Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
                throw "HTTP 404: Session not found"
            }

            { Get-PSquicSession -ServiceId 'invalid-service' } | Should -Throw "HTTP 404: Session not found"
        }

        It 'should accept pipeline input' {
            @('service123', 'service456') | Get-PSquicSession
            
            Should -Invoke Invoke-PSquicRestMethod -ModuleName 'PSquic' -Exactly 2
        }

        It 'should accept pipeline input with ServiceIds property' {
            $services = [PSCustomObject]@{ ServiceIds = 'service123' }
            
            $services | Get-PSquicSession
            
            Should -Invoke Invoke-PSquicRestMethod -ModuleName 'PSquic' -Exactly 1 -ParameterFilter {
                $Uri -eq 'https://api.quic.nz/v1/session?service=service123'
            }
        }

        Context 'When no ServiceId is provided' {
            BeforeEach {
                # Mock Get-PSquicServices to return test services
                Mock Get-PSquicServices -ModuleName 'PSquic' {
                    return @('service123', 'service456', 'service789')
                }
            }

            It 'should automatically get all services and return all sessions' {
                $result = Get-PSquicSession
                
                # Should call Get-PSquicServices once
                Should -Invoke Get-PSquicServices -ModuleName 'PSquic' -Exactly 1
                
                # Should call Invoke-PSquicRestMethod for each service
                Should -Invoke Invoke-PSquicRestMethod -ModuleName 'PSquic' -Exactly 3 -ParameterFilter {
                    $Uri -like 'https://api.quic.nz/v1/session?service=*' -and $Method -eq 'GET'
                }
            }

            It 'should handle errors from individual services gracefully' {
                # Mock to fail on second service but succeed on others
                Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
                    param($Uri)
                    if ($Uri -like '*service456*') {
                        throw "HTTP 404: Service not found"
                    }
                    return @{
                        service = @{ username = 'testuser'; status = 'active' }
                        status = 'connected'
                        sessionType = 'DHCP'
                    }
                } 

                # Should not throw, but continue processing other services
                { Get-PSquicSession } | Should -Not -Throw
                
                # Should still process all services
                Should -Invoke Invoke-PSquicRestMethod -ModuleName 'PSquic' -Exactly 3
            }

            It 'should throw if Get-PSquicServices fails' {
                Mock Get-PSquicServices -ModuleName 'PSquic' {
                    throw "Failed to retrieve services"
                }

                { Get-PSquicSession } | Should -Throw "*Failed to retrieve services*"
            }
        }
    }
}
