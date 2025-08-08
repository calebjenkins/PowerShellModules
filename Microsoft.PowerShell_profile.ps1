# Import-Module posh-git
# Import-Module -Name Terminal-Icons

# # While editing this. Use > . $PROFILE
# # to reload current powershell profile changes

Import-Module Calebs-PSExtensions -Verbose

Set-PoshTheme uniForm (GetFolder ($PROFILE))






function pshelp {
    $Message = _argsToString $args
    _checkParam $Message "Search string is needed for PSHelp"

    websearch "PowerShell $Message"
}

# Open Browser, Search Bing for Sring that is passed in
Set-Alias whelp websearch #web help
function websearch {
    $Message = _argsToString $args
    
    _web-lookup $Message "https://www.bing.com/search?q="
}

function websearchg {
    $Message = _argsToString $args
    
    _web-lookup $Message "https://www.google.com/search?q="
}

function _web-lookup{
    param (
        [Parameter()] [string] $Message,
        [Parameter()] [string] $BaseUrl
    )

    $functionName = [string]$(Get-PSCallStack)[1].FunctionName
    _checkParam $Message "Please include a string parameter in the $functionName command."

    $EncodeMessage = [uri]::EscapeUriString($Message)
    $searchString = $BaseUrl+$EncodeMessage

    web $searchString
}
 
# Open Browser, Search Google for Sring that is passed in
function websearchg {
    param ( [Parameter()] [string] $Message)

    if( !$Message ){
        Write-Output " Please include a search string in websearchg command."
        break
    }

    $EncodeMessage = [uri]::EscapeUriString($Message)
    $searchString = 'https://www.google.com/search?q='+$EncodeMessage

    web $searchString
}
 

Set-Alias web Open-Web
function Open-Web {
    $Message = _argsToString $args
    _checkParam $Message "Please include a URL in web command."

    Start-Process msedge $Message
}



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