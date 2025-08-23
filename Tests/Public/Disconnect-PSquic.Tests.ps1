BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Disconnect-PSquic' -Tag 'Unit', 'Fast' {
    Context 'When API key is set' {
        BeforeEach {
            # Set up an API key
            Connect-PSquic -ApiKey 'test-api-key'
        }

        It 'should clear the ApiKey script variable' {
            Disconnect-PSquic
            
            InModuleScope 'PSquic' {
                $script:ApiKey | Should -BeNullOrEmpty
            }
        }

        It 'should output verbose message when disconnecting' {
            $verboseOutput = Disconnect-PSquic -Verbose 4>&1
            
            $verboseOutput | Should -Match "Disconnected from Quic API - API key cleared"
        }
    }

    Context 'When API key is not set' {
        BeforeEach {
            # Ensure no API key is set
            InModuleScope 'PSquic' {
                $script:ApiKey = $null
            }
        }

        It 'should handle disconnection when no API key was set' {
            { Disconnect-PSquic } | Should -Not -Throw
        }

        It 'should output verbose message about already being disconnected' {
            $verboseOutput = Disconnect-PSquic -Verbose 4>&1
            
            $verboseOutput | Should -Match "Already disconnected - no API key was set"
        }

        It 'should leave ApiKey as null when already null' {
            Disconnect-PSquic
            
            InModuleScope 'PSquic' {
                $script:ApiKey | Should -BeNullOrEmpty
            }
        }
    }

    Context 'Integration with other functions' {
        It 'should prevent other functions from working after disconnect' {
            # Connect first
            Connect-PSquic -ApiKey 'test-api-key'
            
            # Verify connection works (would need API key to work)
            InModuleScope 'PSquic' {
                $script:ApiKey | Should -Be 'test-api-key'
            }
            
            # Disconnect
            Disconnect-PSquic
            
            # Verify other functions now require reconnection
            { Get-PSquicServices } | Should -Throw "*API key not set*"
        }
    }
}
