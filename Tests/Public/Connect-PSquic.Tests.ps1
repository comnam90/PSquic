BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Connect-PSquic' -Tag 'Unit', 'Fast' {
    It 'should set the ApiKey script variable' {
        Connect-PSquic -ApiKey 'test-key'
        
        InModuleScope 'PSquic' {
            $script:ApiKey | Should -Be 'test-key'
        }
    }
}