

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
    Write-Debug $pathToTheme

    $exists = Test-Path -Path $pathToTheme -PathType Leaf
    if ($exists -eq $false) {
        Write-Output "Theme not found - $pathToTheme"
        break
    }

    oh-my-posh init pwsh --config $pathToTheme | Invoke-Expression
}
Export-ModuleMember -Function Set-PoshTheme

function Invoke-PoshTheme {
    
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
Export-ModuleMember -Function Invoke-PoshTheme

function _Set-ProfileEntry {
    param (
        [string]$Key,
        [string]$KeySegment = $Key,
        [string] $profilePath = $PROFILE
    )

    _checkParam $Key "Please provide a profile key"

    if (-not (Test-Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath -Force
    }

    $content = Get-Content $profilePath

    if($content.Contains($KeySegment))
    {
        Write-Output "$KeySegment' already exists in the profile - nothing added."
        break;
    }

    $content = "`n ## Added by script `n$Key`n`n" + $content
    $content | Set-Content $profilePath
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


