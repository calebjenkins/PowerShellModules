
function _writeTitle {

    Write-Output "
 .------------------------------------------------------------------.
 |                                                                  |
 |     ____      _      _     _                                     |
 |    / ___|__ _| | ___| |__ ( )___                                 |
 |   | |   / _` | |/ _ \ '_ \|// __|                                |
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
