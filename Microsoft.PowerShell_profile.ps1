# Import-Module posh-git


# # While editing this. Use > . $PROFILE
# # to reload current powershell profile changes

Import-Module -Name Terminal-Icons
Import-Module Calebs-PSExtensions -Verbose

Set-PoshTheme uniForm (GetFolder ($PROFILE))









# function set-HotKey
# {
#     param (
#          [Parameter(Mandatory=$true, Position=0)] [string] $HotKey,
#          [Parameter(Mandatory=$true, Position=1)] [string] $Description,
#          [Parameter(Mandatory=$true, Position=2)] [string] $Command
#          )

### This doesn't like how we passed in params. ¯\_(ツ)_/¯

#     Set-PSReadLineKeyHandler -Key "$HotKey" `
#                          -BriefDescription TestCurrentDirectory `
#                          -LongDescription "$Description" `
#                          -ScriptBlock {
#                             [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#                             [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$Command")
#                             [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
#                          }
# }

# Set-PSReadLineKeyHandler -Key Ctrl+b `
#                          -BriefDescription BuildCurrentDirectory `
#                          -LongDescription "dotnet Build the current directory" `
#                          -ScriptBlock {
#     [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#     [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet build")
#     [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }

# Set-PSReadLineKeyHandler -Key Ctrl+t `
#                          -BriefDescription TestCurrentDirectory `
#                          -LongDescription "dotnet Test the current directory" `
#                          -ScriptBlock {
#     [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#     [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet test")
#     [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }
# #set-HotKey ("Ctrl+t", "dotnet Test the current directory", "dotnet test")

# Set-PSReadLineKeyHandler -Key Ctrl+r `
#                          -BriefDescription TestCurrentDirectory `
#                          -LongDescription "dotnet Restore the current directory" `
#                          -ScriptBlock {
#     [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#     [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet restore")
#     [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }

# Set-PSReadLineKeyHandler -Key Ctrl+. `
#                          -BriefDescription TestCurrentDirectory `
#                          -LongDescription "Open git url for current directory" `
#                          -ScriptBlock {
#     [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#     [Microsoft.PowerShell.PSConsoleReadLine]::Insert("gitw")
#     [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }