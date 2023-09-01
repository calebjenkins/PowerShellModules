@{
    RootModule        = 'Calebs-PSExtensions.psm1'
    ModuleVersion     = '0.10.0'
    GUID              = ''
    Author            = 'Caleb Jenkins'
    CompanyName       = 'Community'
    Copyright         = '(c) Caleb Jenkins. All rights reserved.'
    Description       = 'PowerShell module to add file icons to terminal based on file extension'
    PowerShellVersion = '5.1'
    # PowerShellHostName = ''
    # PowerShellHostVersion = ''
    RequiredModules = @()
    FunctionsToExport = @('Set-TerminalIconsTheme','Show-TerminalIconsTheme')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('NerdFonts', 'Icon')
            LicenseUri   = 'https://raw.githubusercontent.com/calebjenkins/PowerShellModules/main/LICENSE'
            ProjectUri   = 'https://github.com/calebjenkins/PowerShellModules'
            # IconUri      = 'https://github.com/calebjenkins/PowerShellModules/raw/main/media/icon_256.png'
            # ReleaseNotes = 'https://raw.githubusercontent.com/calebjenkins/PowerShellModules/main/CHANGELOG.md'
        }
    }
}