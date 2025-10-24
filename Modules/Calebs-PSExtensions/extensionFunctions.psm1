
function _writeTitle {

    Write-Output "
 .------------------------------------------------------------------.
 |                                                                  |
 |     ____      _      _     _                                     |
 |    / ___|__ _| | ___| |__ ( )___                                 |
 |   | |   / _`  | |/ _ \ '_ \|// __|                                |
 |   | |__| (_| | |  __/ |_) | \__ \                                |
 |    \____\__,_|_|\___|_.__/  |___/                                |
 |    ____  ____  _____      _                 _                    |
 |   |  _ \/ ___|| ____|_  _| |_ ___ _ __  ___(_) ___  _ __  ___    |
 |   | |_) \___ \|  _| \ \/ / __/ _ \ '_ \/ __| |/ _ \| '_ \/ __|   |
 |   |  __/ ___) | |___ >  <| ||  __/ | | \__ \ | (_) | | | \__ \   |
 |   |_|   |____/|_____/_/\_\\__\___|_| |_|___/_|\___/|_| |_|___/   |
 | github.com/calebjenkins/PowerShellModules      DevelopingUX.com  |
 |                                                                  |
 '------------------------------------------------------------------'
"
}
function Get-CalebPSExtensionVersion {
    param (
        [switch]$about = $false,
        [switch]$help = $false
    )

    if ($about) {
        _writeTitle
    }

    if ($help) {
        Write-Output "Get-CalebPSExtensionVersion - Returns the version of the Caleb's PowerShell Extensions module."
    }

    Write-Output $MyInvocation.MyCommand.Module.Version
}
Set-Alias -Name Calebs-Version -Value Get-CalebPSExtensionVersion
Export-ModuleMember -Function Get-CalebPSExtensionVersion -Alias Calebs-Version


function Import-ModuleIfNeeded {
    param (
        [string] $ModuleName,
        [switch] $allowClobber = $false,
        [switch] $verbose = $false
    )
    _checkParam $ModuleName "Please provide a module name"

    if ($verbose) {
        Write-Host "Checking if module '$ModuleName' is needed..."
    }

    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        if ($verbose) {
            Write-Host "Module '$ModuleName' is not installed. Installing..."
        }
        Install-Module -Name $ModuleName -Scope CurrentUser -Force -Repository PSGallery -AllowClobber:$allowClobber
    }
    Import-Module -Name $ModuleName -Global -Force
}
Export-ModuleMember -Function Import-ModuleIfNeeded


#          ____
#         / _\ \
#       .'\/  \ \
#     ,'   \   \ \
#      / /-'    \ \ .
#     / /       ,\ '|
#    / /        '-._|
#   / /_.'|________\_\
#   \/_<  ___________/
#       '.|

### Not *Yet* Used ###

function Add-ImportToProfile {
    param (
        [string]$ModuleName,
        [switch]$verbose = $false,
        [switch]$prepend = $false,
        [switch]$showEdits = $false
    )

    _checkParam $ModuleName "Please provide a module name"

    $profilePath = $PROFILE
    $profileContent = Get-Content $profilePath -Raw

    if ($profileContent -notmatch "Import-Module $ModuleName") {
        $profileContent += "`nImport-Module $ModuleName"
        Set-Content -Path $profilePath -Value $profileContent
        Write-Host "Added 'Import-Module $ModuleName' to $profilePath"
    }
}

function Add-DirectoryToModulePath {
    param (
        [string]$FolderPath
    )

    _checkParam $FolderPath "Please provide a folder path to add to the PSModulePath"

    $currentDir = $FolderPath
    
    $paths = $env:PSModulePath -split ';'
    if ($paths -notcontains $currentDir) {
        $env:PSModulePath += ";$currentDir"
        Write-Host "Added $currentDir to PSModulePath."
    }
}

function Get-UserSettings {
    param (
        [string] $App
    )

    _checkParam $App "Please provide an application name"

    $settingsPath = "$env:USERPROFILE\.powershell\$App-settings.json"

    if (Test-Path $settingsPath) {
        return Get-Content $settingsPath | ConvertFrom-Json
    }
    else {
        Write-Output "No settings found for $App. Returning empty object."
        return @{}
    }
}

function Set-UserSetting {
    param(
        [string] $App,
        [string]$Key,
        [string]$Value
    )
    _checkParam $App "Please provide an application name"
    _checkParam $Key "Please provide a setting key"
    _checkParam $Value "Please provide a setting value"
    
    $settingsPath = "$env:USERPROFILE\.powershell\$App-settings.json"
    $settings = Get-UserSettings $App
    $settings.$Key = $Value
    
    # Ensure directory exists
    $settingsDir = Split-Path $settingsPath
    if (!(Test-Path $settingsDir)) {
        New-Item -ItemType Directory -Path $settingsDir -Force
    }
    
    $settings | ConvertTo-Json | Out-File $settingsPath
}

function SetUp-CalebExtensions {
    param (
        [switch]$verbose = $false,
        [switch]$help = $false,
        [switch]$all = $false,
        [switch]$updateProfile = $false,
        [switch]$TerminalIcons = $false,
        [switch]$ohmyposh = $false,
        [switch]$vscode = $false
    )


    $allParams = @($verbose, $help, $all, $updateProfile, $TerminalIcons, $ohmyposh, $vscode)
    if ($help -and (($allParams -notcontains $true))) {
        _printSetUpHelp
        return
    }

    Import-ModuleIfNeeded -ModuleName "Calebs-PSExtensions" -verbose:$verbose -allowClobber

    if($all -or $updateProfile) {
        Add-ImportToProfile -ModuleName "Calebs-PSExtensions" -verbose:$verbose
    }

    if($all -or $TerminalIcons) {
        Import-ModuleIfNeeded -ModuleName "Terminal-Icons" -verbose:$verbose -allowClobber
        if($all -or $updateProfile) {
            Add-ImportToProfile -ModuleName "Terminal-Icons" -verbose:$verbose
        }
    }
    if($all -or $vscode) {
        Install-Application "Microsoft.VisualStudioCode" -verbose:$verbose
        if($ohmyposh)
        {
            oh-my-posh font install meslo    
        }
        # Set Terminal font to MesloLGM Nerd Font
        # Set VS Code Terminal font to MesloLGM Nerd Font
    }

    if($all -or $ohmyposh) {
        Install-Application "janDeDobbeleer.OhMyPosh" -verbose:$verbose
        $env:POSH_GIT_ENABLED = $true

        oh-my-posh font install meslo
        Set-WindowsTerminalDefaultFont  "MesloLGM Nerd Font"

    }


}

function _printSetUpHelp
{
    Calebs-Version -about
    Write-Output "SetUp-CalebExtensions - Sets up Caleb's PowerShell Extensions module for use."
    Write-Output "This includes importing the module and adding it to your PowerShell profile for automatic loading."
    Write-Output ""
    Write-Output "Parameters:"
    Write-Output "  -verbose : Enables verbose output during setup."
    Write-Output "  -all     : (Future Use) Sets up all related modules and dependencies."
    Write-Output ""
    Write-Output "Example Usage:"
    Write-Output "  SetUp-CalebExtensions -verbose"
}

function Install-Application
{
    param (
        [string]$AppName,
        [switch]$verbose = $false
    )

    _checkParam $AppName "Please provide an application name to install"

    if($IsWindows)
    {
        _install-Application-Winget $AppName -verbose:$verbose
    }
    elseif ($IsMacOS)
    {
        _install-Application-HomeBrew $AppName -verbose:$verbose
    }   
    else 
    {
        Write-Output "Unsupported OS for application installation."
    }
}

function _printVerbose  
{
    param (
        [string]$Message,
        [switch]$verbose = $false
    )

    if ($verbose) {
        Write-Host $Message
    }
}

function _install-Application-Winget
{
    param (
        [string]$AppName,
        [switch]$verbose = $false
    )
    _checkWindows

    winget list -q $AppName | Out-Null

    if ($?) {  _printVerbose "$AppName aleady installed", $verbose; return }

    winget install --id $AppName -e --source winget

switch ($AppName.ToLower()) {
        "vscode" {
            if ($verbose) { Write-Host "Installing $AppName ..." }
            winget install --id $AppName -e --source winget
        }
        
        default {
            Write-Output "'$AppName' not found."
        }
    }
}

function _install-Application-HomeBrew
{
    param (
        [string]$AppName,
        [switch]$verbose = $false
    )

# Check if the application is installed via Homebrew
$installed = brew list --formula | Where-Object { $_ -eq $AppName }

if ($installed) {
    Write-Host "$AppName is already installed via Homebrew."
} else {
    Write-Host "$AppName is not installed. Installing now..."
    brew install $AppName

    # Confirm installation
    if (brew list --formula | Where-Object { $_ -eq $AppName }) {
        Write-Host "$AppName was successfully installed."
    } else {
        Write-Host "Failed to install $AppName."
    }
}
}