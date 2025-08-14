# PowerShellModules
a collection of PowerShell modules that might be helpful.


## Install
`Install-Module Calebs-PSExtensions`

Update Your Powershell Profile:
```
code $PROFILE
```
(this assumes you have `VS Code` already installed. )

Add to profile: 
```
Import-Module Caleb's PSExensions
```

## Structure
- 📂 root folder
  - 📂Modules
    - 📂Calebs-PSExtension
      - 📄Calebs-PSExtensions.psd1
      - 📄_privFunctions.psm1
      - 📄extensionFunctions.psm1
      - 📄fileFunctions.psm1
      - 📄gitFunctions.psm1
      - 📄poshFunctions.psm1
      - 📄webFunctions.psm1
      - 📄Write-Ascii.psm1
    - 📁Calebs-PSExtensions-Tests
- 📄publish.ps1
- 📄Reload.ps1
- 📄README.md

## Structure Details

### Calebs-PSExtensions.psd1
This file represents the overall module (collections of methods). This is used for publishing, versioning and managing dependencies.

### _privFunctions.psm1
