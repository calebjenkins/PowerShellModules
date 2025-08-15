
# Dev
 $devModules = '~/Source/GH/_CJ/PowerShellModules/Modules/'
 $paths = $env:PSModulePath -split ';'
    if ($paths -notcontains $devModules) {
        $env:PSModulePath += ";$devModules"
        Write-Host "Added $devModules to PSModulePath."
    }

. ./Reload.ps1

Import-ModuleIfNeeded "Microsoft.PowerShell.SecretManagement"