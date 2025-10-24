# Calebs-PSExtensions
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
```
📂 root folder
├──📂Modules
│  └──📂Calebs-PSExtension
│  │   ├─📄Calebs-PSExtensions.psd1
│  │   ├─📄_privFunctions.psm1
│  │   ├─📄extensionFunctions.psm1
│  │   ├─📄fileFunctions.psm1
│  │   ├─📄gitFunctions.psm1
│  │   ├─📄poshFunctions.psm1
│  │   ├─📄webFunctions.psm1
│  │   └─📄Write-Ascii.psm1
│  └──📁Calebs-PSExtensions-Tests (Currently un-used, experimenting with Pester)
├─📄publish.ps1
├─📄Reload.ps1
├─📄README.md
└─📄SetUp-LocalDev.ps1
```
## Structure Details

### Calebs-PSExtensions.psd1
This file represents the overall module (collections of methods). This is used for publishing, versioning and managing dependencies.

### _privFunctions
These functions are used by othere functions, not of them are intended to be used directly. By convention private functions do not attempt to follow PowerShell Verb-Noun naming conventions and are all prefixed with an `_`underscore.

  - **_checkParam** - Checks that the supplied `[string]` parameter is not blank or empty. Provides a more user friendly experience and halts execution if the parameter is missing. It's like making a paremter required, only nicer.
  - **_argToString** - Takes in all parameters and joins them as a single string. 
  - **_checkIntValue** - Similiar to `_checkParam` only this is designed to work with int values, and confirm they are within a specific range.
  - **_checkWindows** - confirms that the host OS is Windows, and provides a friendly message and halts execution if it is not. 

### extensionFunctions
Public functions that are used to manage and set up these extensions and other environment dependencies. For example, loading external modules or updating PowerShell profiles.
  - **Get-CalebsPSExtensionVersion** (alias _Calebs-Version_) - Displays the version of the Calebs-PSExtensions that is installed. 
    - Flags / Parameters:
      - **--about** - displays a welcome message in ascii art
      - **--help** - displays a list of available commandlets included with `Calebs-PSExtensions`
  - **Import-ModuleIfNeeded** (alias: none) - This method first checks if the module is locally available, and if it's not performs `Install-Module` before calling `Import-Module`.
    - Flags / Parameters:
      - **ModuleName** - The only required parameter (string). The name of the module to Install/Import.
      - **allowClobber** (flag) - This is passed through to the Install-Module call. Usefull if you know there is a potencial naming or alias collision.
      - **verbose** (flag) - when included, more logging is output to the terminal.

### fileFunctions
Useful functions for working with files. These are mostly cross platform, however GetFolder (super usefull) hasn't worked on mac os for a bit.
  - **Get-PathToFolder** (alias: _GetFolder_) - this returns the full path to a provider folder, or to the parent folder if a file path is supplied. For example, you can use this to change director to the folder with `$PROFILE` in it by using `> CD GetFolder($PROFILE)` 
  - **Alias: Raname** - we set this alias for `Move-Item` so that `Rename` can work in PowerShell
  - **Alias: Open** - we set this alias for `Invoke-Item` (also `ii`) so that `open` can work in PowerShell

### gitFunctions
Functions to make working with git super enjoyable.
  - **Open-GitRemopteUrl** (alias: _gitw_) - opens the `origin` remote url in a browser for a git repo that you are in. Attempts to take you to the URL for the current branch.
    - Parameter (optional): **RemoteName** this defaults to `origin` but you can optionally specific a remote url. This is especially useful if you have an `upstream` remote, and you would like to open that instead or `origin`
  - **Invoke-GitCommitAndPush** (alias: _gitc_) - performs `git add .`, followed by `git commit $message` then `git push`.
    - Usage: `gitc "This is my commit message"` 
  - **Initialize-GitRepo** (alias _gitinit_) - Checks if this is already a git repo, if it is, we stop. Performs `git init`, imports a `.gitignore` file from a shared set of `gitignore` files from [GitHub](https://github.com/github/gitignore/tree/main). Performs an initial commit with `Initial commit` message.  _Future Idea:_ I think in the future, this would be a good place to check that the default branch is `main` and if not, set it up that way. ¯\_(ツ)_/¯
  - **Add-GitIgnore** (alias _gitignore_) - Used by `gitinit` this function pulls down a git ignore from [GitHub](https://github.com/github/gitignore/tree/main) and adds that `.gitignore` file to the current repo.  By default, we pull down that [VisualStudio](https://github.com/github/gitignore/blob/main/VisualStudio.gitignore) ignore file but you can specify any ignore file that exists in [this repo](https://github.com/github/gitignore/tree/main). Some common examples: `gitignore` [AI](https://github.com/github/gitignore/blob/main/AL.gitignore), `gitignore` [Java](https://github.com/github/gitignore/blob/main/Java.gitignore), `gitignore` [ExtJS](https://github.com/github/gitignore/blob/main/ExtJs.gitignore), `gitignore` [Python](https://github.com/github/gitignore/blob/main/Python.gitignore), etc.. Note: These are case sensative!
  - **Get-GitClone** (alias: _clone_) This is the same as `git clone URL`, save a little typing to use `clone URL`

### poshFunctions
We like `Oh My Posh`. These functions are designed to make setting up and modifying oh my posh even easier.

### webFunctions
Do you use the web all the time? Us too! These are PS functions that mostly allow you to launch web activities from your terminal.

## History
- 0.5.0 - initial publish the core `Calebs-PSExtensions modules files. 
