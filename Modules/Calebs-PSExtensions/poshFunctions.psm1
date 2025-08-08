Set-Alias Theme Set-PoshTheme
function Set-PoshTheme {
    param (
        [Parameter(Position = 0)] [string]$themeName,
        [Parameter(Position = 1)] [string]$source = $env:POSH_THEMES_PATH
    )

    _checkParam $themeName

    $pathToTheme = $source + "/" + $themeName + ".omp.json"

    $exists = Test-Path -Path $pathToTheme -PathType Leaf
    if ($exists -eq $false) {
        Write-Output "Theme not found"
        break
    }

    oh-my-posh init pwsh --config $pathToTheme | Invoke-Expression
}

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

    _CheckWindows

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

    _CheckWindows

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