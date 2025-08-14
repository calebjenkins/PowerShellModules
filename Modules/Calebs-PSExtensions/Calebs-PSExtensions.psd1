@{
    ModuleVersion     = '0.0.5'
    Author            = 'Caleb Jenkins'
    CompanyName       = 'DevelopingUX'
    Copyright         = '(c) Caleb Jenkins. All rights reserved.'
    Description       = 'PowerShell module of useful cmdlet extensions'
    PowerShellVersion = '7.0'
    NestedModules  = @(
                '_privFunctions.psm1',
                'extensionFunctions.psm1',
                'gitFunctions.psm1',
                'fileFunctions.psm1',
                'poshFunctions.psm1',
                'webFunctions.psm1'
    )
    
    PrivateData       = @{
        PSData = @{
            Tags         = @('PowerShell', 'Extensions')
            LicenseUri   = 'https://raw.githubusercontent.com/calebjenkins/PowerShellModules/main/LICENSE'
            ProjectUri   = 'https://github.com/calebjenkins/PowerShellModules'
            # IconUri      = 'https://github.com/calebjenkins/PowerShellModules/raw/main/media/icon_256.png'
            # ReleaseNotes = 'https://raw.githubusercontent.com/calebjenkins/PowerShellModules/main/CHANGELOG.md'
        }
    }
}