BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Invoke-PSquicRestMethod' {
    Context 'when Connect-PSquic has not been run' {
        BeforeEach {
            # Clear the ApiKey variable before each test in the module scope
            InModuleScope 'PSquic' {
                Remove-Variable -Name ApiKey -Scope Script -ErrorAction SilentlyContinue
            }
        }
        
        It 'should throw an error' {
            InModuleScope 'PSquic' {
                { Invoke-PSquicRestMethod -Uri 'https://api.example.com' } | Should -Throw 'API key not set. Please run Connect-PSquic first.'
            }
        }
    }

    Context 'when Connect-PSquic has been run' {
        BeforeAll {
            Connect-PSquic -ApiKey 'test-key'
        }

        It 'should call Invoke-RestMethod with the correct parameters' -Skip {}
    }
}
