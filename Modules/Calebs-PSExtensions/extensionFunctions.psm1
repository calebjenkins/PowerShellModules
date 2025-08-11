

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

# Add-CurrentDirectoryToModulePath

# Public Function (Having one declared forces the rest to be private)
function Import-ModuleIfNeeded {
    param (
        [string] $ModuleName
    )
    _checkParam $ModuleName "Please provide a module name"

    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Install-Module -Name $ModuleName -Scope CurrentUser -Force -Repository PSGallery
    }
    
    Import-Module -Name $ModuleName -Global
}
Export-ModuleMember -Function Import-ModuleIfNeeded

function Get-CalebPSExtensionVersion
{
    Write-Output $MyInvocation.MyCommand.Module.Version
}
Set-Alias -Name Calebs-Version -Value Get-CalebPSExtensionVersion
Export-ModuleMember -Function Get-CalebPSExtensionVersion -Alias Calebs-Version