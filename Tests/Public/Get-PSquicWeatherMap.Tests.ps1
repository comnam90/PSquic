BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}

Describe 'Get-PSquicWeatherMap' {
    BeforeEach {
        # Mock the private function
        Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
            return [byte[]](1..100)  # Mock binary data
        }
        
        # Mock Invoke-RestMethod for direct file downloads at the global level
        Mock Invoke-RestMethod {
            # Simulate downloading to file
        }
        
        # Mock file system operations
        Mock Test-Path { return $true }
        Mock New-Item { }
        Mock Get-Item { 
            return [PSCustomObject]@{
                FullName = $Path
                Length = 1024
                LastWriteTime = Get-Date
            }
        } -ModuleName 'PSquic'
    }

    Context 'When API key is not set' {
        BeforeEach {
            InModuleScope 'PSquic' {
                $script:ApiKey = $null
            }
        }

        It 'should throw an error about missing API key when downloading to memory' {
            Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
                throw "API key not set. Please run Connect-PSquic first."
            }

            { Get-PSquicWeatherMap } | Should -Throw "*API key not set*"
        }

        It 'should throw an error about missing API key when downloading to file' {
            InModuleScope 'PSquic' {
                $script:ApiKey = $null
            }

            { Get-PSquicWeatherMap -OutFile 'test.jpg' } | Should -Throw "*API key not set*"
        }
    }

    Context 'When API key is set' {
        BeforeEach {
            InModuleScope 'PSquic' {
                $script:ApiKey = 'test-api-key'
            }
        }

        Context 'When downloading to memory' {
            It 'should call the correct API endpoint' {
                Get-PSquicWeatherMap
                
                Should -Invoke Invoke-PSquicRestMethod -ModuleName 'PSquic' -Times 1 -ParameterFilter {
                    $Uri -eq 'https://api.quic.nz/v1/weathermap' -and $Method -eq 'GET'
                }
            }

            It 'should return binary data' {
                $result = Get-PSquicWeatherMap
                
                $result | Should -BeOfType [byte]
                $result[0] | Should -Be 1
            }
        }

        Context 'When downloading to file' {
            BeforeEach {
                # Mock the direct Invoke-RestMethod call used in the OutFile path at module level
                Mock Invoke-RestMethod { } -ModuleName 'PSquic' -ParameterFilter { $OutFile }
            }

            It 'should call Invoke-RestMethod directly with OutFile parameter' {
                Get-PSquicWeatherMap -OutFile '/tmp/weathermap.jpg'
                
                Should -Invoke Invoke-RestMethod -ModuleName 'PSquic' -Times 1 -ParameterFilter {
                    $Uri -eq 'https://api.quic.nz/v1/weathermap' -and 
                    $Method -eq 'GET' -and
                    $OutFile -eq '/tmp/weathermap.jpg' -and
                    $Headers.'X-API-Key' -eq 'test-api-key'
                }
            }

            It 'should return FileInfo object when saving to file' {
                Mock Get-Item { 
                    return [PSCustomObject]@{
                        FullName = '/tmp/weathermap.jpg'
                        Length = 2048
                        LastWriteTime = Get-Date
                    }
                } -ModuleName 'PSquic'

                $result = Get-PSquicWeatherMap -OutFile '/tmp/weathermap.jpg'
                
                $result.FullName | Should -Be '/tmp/weathermap.jpg'
            }

            It 'should create directory if it does not exist' {
                Mock Test-Path { return $false } -ParameterFilter { $Path -eq '/tmp' } -ModuleName 'PSquic'
                Mock New-Item { } -ParameterFilter { $Path -eq '/tmp' -and $ItemType -eq 'Directory' } -ModuleName 'PSquic'

                Get-PSquicWeatherMap -OutFile '/tmp/weathermap.jpg'
                
                Should -Invoke New-Item -ModuleName 'PSquic' -Times 1 -ParameterFilter {
                    $Path -eq '/tmp' -and $ItemType -eq 'Directory' -and $Force -eq $true
                }
            }
        }

        It 'should handle API errors gracefully' {
            Mock Invoke-PSquicRestMethod -ModuleName 'PSquic' {
                throw "HTTP 500: Internal Server Error"
            }

            { Get-PSquicWeatherMap } | Should -Throw "HTTP 500: Internal Server Error"
        }
    }
}
