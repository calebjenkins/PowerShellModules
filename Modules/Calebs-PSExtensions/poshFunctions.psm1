

function Set-PoshTheme {
    param (
        [Parameter(Position = 0)] [string]$themeName,
        [Parameter(Position = 1)] [string]$source = $env:POSH_THEMES_PATH
    )

    _checkParam $themeName

    $extension = ".omp.json"
    if ($themeName.EndsWith($extension))
    {
        $extension = ""
    } 

    $pathToTheme = Join-Path -Path $source -ChildPath ($themeName + $extension)

    $exists = Test-Path -Path $pathToTheme -PathType Leaf
    if ($exists -eq $false) {
        Write-Output "Theme not found - $pathToTheme"
        break
    }

    oh-my-posh init pwsh --config $pathToTheme | Invoke-Expression
}
Set-Alias Theme Set-PoshTheme
Export-ModuleMember -Function Set-PoshTheme -Alias Theme

function Invoke-PoshThemes {
    
    $source = $env:POSH_THEMES_PATH

    if (-not (Test-Path -Path $source -PathType Container)) {
        Write-Output "Themes directory not found"
        return @()
    }

    $themes = Get-ChildItem -Path $source -Filter "*.omp.json" | Select-Object -ExpandProperty Name
    
    $selected = $themes | Out-GridView -Title "Select a theme" -PassThru
    Write-Host "You selected: $selected"

    Set-PoshTheme -themeName $selected
}
Export-ModuleMember -Function Invoke-PoshThemes

function Set-UpPostGit {
    ## SET UP ##
    # Before you can use oh-my-posh on Windows: #
    # > winget install janDeDobbeleer.OhMyPosh
    # > oh-my-posh font install 
    Set-PoshFont
    $env:POSH_GIT_ENABLED = $true
}


function Set-PoshFont {
    param (
        [string]$FontName = "MesloLGM Nerd Font"
    )

    _checkWindows

    # Ensure Oh My Posh is installed
    if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
        winget install JanDeDobbeleer.OhMyPosh -s winget
    }

    # List available fonts
    # oh-my-posh font list

    # Install a specific font (e.g., MesloLGS NF)
    oh-my-posh font install $FontName

    # Or prompt user to select a font
    # oh-my-posh font install

    Set-WindowsTerminalDefaultFont $FontName
}

function Set-WindowsTerminalDefaultFont {
    param(
        [string]$FontName = "Cascadia Code"
    )

    _checkWindows

    $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

    $defaultProfileGuid = $settings.defaultProfile
    $vsProfile = $settings.profiles.list | Where-Object { $_.guid -eq $defaultProfileGuid }
    if ($vsProfile) {
        $vsProfile.fontFace = $FontName
        $settings | ConvertTo-Json -Depth 100 | Set-Content $settingsPath
        Write-Host "Font for WindowsTerminal default profile set to $FontName."
    }
    else {
        Write-Host "Default profile not found."
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
Export-ModuleMember -Function Get-UserSettings

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
Export-ModuleMember -Function Set-UserSetting
