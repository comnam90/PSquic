# PSquic Module Test Fixes Summary

## Issues Found and Resolved

### 1. Module Import Issues
**Problem**: Tests were failing because PowerShell couldn't find the module functions (`Connect-PSquic`, `Invoke-PSquicRestMethod`, `Test-Func`).

**Solution**: Added `BeforeAll` blocks to each test file to import the module:
```powershell
BeforeAll {
    # Import the module for testing
    Import-Module "$PSScriptRoot/../../Source/PSquic.psd1" -Force
}
```

### 2. Scope Issues with Script Variables
**Problem**: The `Connect-PSquic` test was trying to access `$script:ApiKey` from the test scope, but the variable was set in the module scope.

**Solution**: Used `InModuleScope` to access module-scoped variables and functions:
```powershell
InModuleScope 'PSquic' {
    $script:ApiKey | Should -Be 'test-key'
}
```

### 3. Private Function Testing
**Problem**: Private functions like `Test-Func` and `Invoke-PSquicRestMethod` weren't accessible from outside the module.

**Solution**: Used `InModuleScope` to test private functions within the module's context.

### 4. Inconsistent Loading Approach
**Problem**: Some test files used dot-sourcing while others didn't load functions at all.

**Solution**: Standardized all test files to use module import with `InModuleScope` for consistent behavior.

## Current Test Status
- ✅ 3 tests passing
- ⏭️ 1 test skipped (intentionally)
- ❌ 0 tests failing

## Best Practices Applied

1. **Module Import**: All test files properly import the module using relative paths
2. **Scope Management**: Used `InModuleScope` for testing private functions and accessing module variables
3. **Test Isolation**: Added `BeforeEach` blocks to clear state between tests
4. **Consistent Structure**: All test files follow the same pattern with `BeforeAll` for setup

## Recommendations for Future

1. Consider creating a shared test helper file to reduce duplication of module import logic
2. Implement more comprehensive tests for the skipped test case
3. Add tests for error conditions and edge cases
4. Consider using test doubles/mocks for external dependencies like `Invoke-RestMethod`
