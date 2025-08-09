# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.1] - 2025-08-09

### Added

- Initial release of PSquic PowerShell module for interacting with the Quic API
- Core functionality for Quic ISP network session data and services retrieval
- `Connect-PSquic` cmdlet for establishing API connections with authentication support
- `Disconnect-PSquic` cmdlet for properly closing API connections
- `Get-PSquicServices` cmdlet for retrieving available Quic services
- `Get-PSquicSession` cmdlet for retrieving session data with support for:
  - Individual session retrieval by Session ID
  - Automatic retrieval of all sessions across all services
  - Robust error handling and validation
- `Get-PSquicWeatherMap` cmdlet for retrieving weather map data
- Private helper functions:
  - `Invoke-PSquicRestMethod` for standardized REST API calls
  - `Test-Func` for internal testing utilities
- Comprehensive unit tests using Pester framework
- Integration tests for API functionality
- Complete documentation for all public cmdlets with examples
- OpenAPI specification (openapi.json) for the Quic API endpoints
- PowerShell 5.1+ compatibility
- Proper module manifest (PSquic.psd1) with metadata and exports

### Changed

- Enhanced `Get-PSquicSession` output method to use `Write-Output` for consistency
- Improved error handling across all cmdlets
- Refined function documentation with additional examples and clarifications

### Fixed

- Corrected indentation and comment formatting in `Get-PSquicSession` function
- Fixed hashtable syntax in PSquic.psd1 module manifest
- Resolved Pester test framework compatibility issues
- Updated module metadata with correct GUID, author, company name, and copyright information

---

## Template for Future Releases

When adding new versions, use the following template:

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Now removed features

### Fixed
- Bug fixes

### Security
- Vulnerability fixes
```

---

**Note**: This changelog is automatically maintained. For detailed commit history, please refer to the [GitHub repository](https://github.com/comnam90/PSquic/commits/main).
