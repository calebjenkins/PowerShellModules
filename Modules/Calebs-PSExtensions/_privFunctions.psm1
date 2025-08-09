### Private Functions _ ##

function _checkParam {
    param (
        [Parameter()] [string] $Value,
        [Parameter()] [string] $ErrorMessage = "Please provide a value"
    )

    if( (!$Value) -or ($Value -eq '') )
    {
        Write-Output $ErrorMessage
        break
    }
}

function _argsToString
{
    $stringArray = ''

    foreach ($param in $args)
    {
        $stringArray = $stringArray + ' ' + $param
    }

    return $stringArray.Trim()
}
function _checkIntValue{
    param (
        [Parameter(Mandatory = $true)] [int] $Value,
        [Parameter(Mandatory = $false)] [int] $MinValue = 0,
        [Parameter(Mandatory = $true)] [int] $MaxValue,
        [Parameter(Mandatory = $true)] [string] $ErrorMessage
    )

    if( (!$Value) -or ($Value -lt $MinValue) -or ($Value -gt $MaxValue))
    {
        Write-Output $ErrorMessage
        break
    }
} 

function _CheckWindows
{
    if (!$IsWindows)
    {
        Write-Output "This function is only supported on Windows."
        break
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
    } else {
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

