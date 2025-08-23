# PSquic Test Configuration for Pester v5
# This file demonstrates how to configure Pester v5 for the PSquic module

# Create configuration for different test scenarios
$config = New-PesterConfiguration

# General configuration
$config.Run.Path = './Tests'
$config.Run.PassThru = $true
$config.Output.Verbosity = 'Detailed'
$config.TestResult.Enabled = $true
$config.TestResult.OutputFormat = 'NUnitXml'
$config.TestResult.OutputPath = './TestResults.xml'
$config.Should.ErrorAction = 'Continue'

# Run all tests
Write-Host "Running all tests..." -ForegroundColor Green
$allResults = Invoke-Pester -Configuration $config

# Fast unit tests only
Write-Host "Running fast unit tests only..." -ForegroundColor Green
$fastConfig = $config.Clone()
$fastConfig.Filter.Tag = 'Fast'
$fastConfig.Filter.ExcludeTag = 'Slow', 'Integration'
$fastResults = Invoke-Pester -Configuration $fastConfig

# Integration tests only
Write-Host "Running integration tests only..." -ForegroundColor Green
$integrationConfig = $config.Clone()
$integrationConfig.Filter.Tag = 'Integration'
$integrationResults = Invoke-Pester -Configuration $integrationConfig

# Unit tests only (excluding integration)
Write-Host "Running unit tests only..." -ForegroundColor Green
$unitConfig = $config.Clone()
$unitConfig.Filter.Tag = 'Unit'
$unitConfig.Filter.ExcludeTag = 'Integration'
$unitResults = Invoke-Pester -Configuration $unitConfig

# Display summary
Write-Host "`nTest Summary:" -ForegroundColor Yellow
Write-Host "All tests: $($allResults.TotalCount) total, $($allResults.PassedCount) passed, $($allResults.FailedCount) failed" -ForegroundColor White
Write-Host "Fast unit tests: $($fastResults.TotalCount) total, $($fastResults.PassedCount) passed, $($fastResults.FailedCount) failed" -ForegroundColor White
Write-Host "Integration tests: $($integrationResults.TotalCount) total, $($integrationResults.PassedCount) passed, $($integrationResults.FailedCount) failed" -ForegroundColor White
Write-Host "Unit tests: $($unitResults.TotalCount) total, $($unitResults.PassedCount) passed, $($unitResults.FailedCount) failed" -ForegroundColor White

# Exit with error code if any tests failed
if ($allResults.FailedCount -gt 0) {
    exit 1
}
