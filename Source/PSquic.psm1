# Main module file for PSquic

# Dot-source the private functions
Get-ChildItem -Path "$PSScriptRoot/Private" -Filter "*.ps1" -Recurse | ForEach-Object { . $_.FullName }

# Dot-source the public functions
Get-ChildItem -Path "$PSScriptRoot/Public" -Filter "*.ps1" -Recurse | ForEach-Object { . $_.FullName }
