Import-Module posh-git
Import-Module oh-my-posh
Import-Module -Name Terminal-Icons

# While editing this. Use > . $PROFILE
# to reload current powershell profile changes

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine
}

Set-Theme Paramox

function FindFile{
    param ( [string]$filePattern)
    Get-ChildItem -Recurse -Filter $filePattern
}

function DirSize {
    param ( [string]$Folder )

    # Get file count and cummulative sizes
    $files = Get-ChildItem $Folder -Recurse | Measure-Object length -Sum
    $fileCount = $files.Count
    $fileSize = $files.Sum/1MB

    # Get directory count
    $folderCount = (Get-ChildItem $Folder -Recurse -Directory | Measure-Object).Count

    # Export Data
    [PSCustomObject]@{ "Folder" = $Folder; "SubFolderCount" = $folderCount; "FileCount" = $fileCount; "TotalSize (MB)" = $fileSize}
}

function GitW {

    $repoUrl = git config --get remote.origin.url
    if(!$repoUrl)
    {
        Write-Output " No git URL found"
        break
    }

    # Start-Process chrome $repoUrl
    Start-Process $repoUrl
}

function gitc {
    param (
        [Parameter()] [string] $Message
        )

    $repoUrl = git config --get remote.origin.url
    if(!$repoUrl)
    {
        Write-Output " No git URL found"
        break
    }

    git add .
    git commit -m "$message"
    git push
}

function pshelp {
    param ( [Parameter()] [string] $Message)
    _checkParam $Message "Search string is needed for PSHelp"

    websearch "PowerShell $Message"
}

# Open Browser, Search Bing for Sring that is passed in
function websearch {
    param ( [Parameter()] [string] $Message)
    
    _web-lookup $Message "https://www.bing.com/search?q="
}

function websearchg {
    param ( [Parameter()] [string] $Message)
    
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
    param (
        [Parameter()] [string] $Message
    )

    _checkParam $Message "Please include a URL in web command."

    Start-Process msedge $Message
}

### Private Functions _ ##

function _checkParam {
    param (
        [Parameter()] [string] $Value,
        [Parameter()] [string] $ErrorMessage
    )

    if( (!$Value) -or ($Value -eq '') )
    {
        Write-Output $ErrorMessage
        break
    }
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

# function set-HotKey
# {
#     param (
#          [Parameter(Mandatory=$true, Position=0)] [string] $HotKey,
#          [Parameter(Mandatory=$true, Position=1)] [string] $Description,
#          [Parameter(Mandatory=$true, Position=2)] [string] $Command
#          )

### This doesn't like how we passed in params. ??\_(???)_/??

#     Set-PSReadLineKeyHandler -Key "$HotKey" `
#                          -BriefDescription TestCurrentDirectory `
#                          -LongDescription "$Description" `
#                          -ScriptBlock {
#                             [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#                             [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$Command")
#                             [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
#                          }
# }

Set-PSReadLineKeyHandler -Key Ctrl+b `
                         -BriefDescription BuildCurrentDirectory `
                         -LongDescription "dotnet Build the current directory" `
                         -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet build")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

Set-PSReadLineKeyHandler -Key Ctrl+t `
                         -BriefDescription TestCurrentDirectory `
                         -LongDescription "dotnet Test the current directory" `
                         -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet test")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
#set-HotKey ("Ctrl+t", "dotnet Test the current directory", "dotnet test")

Set-PSReadLineKeyHandler -Key Ctrl+r `
                         -BriefDescription TestCurrentDirectory `
                         -LongDescription "dotnet Restore the current directory" `
                         -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("dotnet restore")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

Set-PSReadLineKeyHandler -Key Ctrl+. `
                         -BriefDescription TestCurrentDirectory `
                         -LongDescription "Open git url for current directory" `
                         -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("gitw")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}