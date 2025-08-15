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

### _privFunctions
These functions are used by othere functions, not of them are intended to be used directly.

  - **_checkParam** - Checks that the supplied `[string]` parameter is not blank or empty. Provides a more user friendly experience and halts execution if the parameter is missing. It's like making a paremter required, only nicer.

### extensionFunctions
Public functions that are used to manage and set up these extensions and other environment dependencies. For example, loading external modules or updating PowerShell profiles.

### fileFunctions
Useful functions for working with files. These are mostly cross platform, however GetFolder (super usefull) hasn't worked on mac os for a bit.

### gitFunctions
Functions to make working with git super enjoyable.

### poshFunctions
We like Oh My Posh. These functions are designed to make setting up and modifying oh my posh even easier.

### webFunctions
Do you use the web all the time? Us too! These are PS functions that mostly allow you to launch web activities from your terminal.
