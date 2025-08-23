BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Test-Func' -Tag 'Unit', 'Fast' {
    It 'should return Hello' {
        InModuleScope 'PSquic' {
            Test-Func | Should -Be "Hello"
        }
    }
}
