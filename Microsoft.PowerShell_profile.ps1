Import-Module posh-git
Import-Module oh-my-posh
Import-Module -Name Terminal-Icons

# While editing this. Use > . $PROFILE
# to reload current powershell profile changes

# if ($host.Name -eq 'ConsoleHost')
# {
#     Import-Module PSReadLine
# }

Set-Theme Paramox

Set-Alias Rename Move-Item
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

function Open-Folder {
    param ( [string]$FilePath )
    _checkParam $FilePath "Please provide a file path to use this command"

    $folderPath = $FilePath

    if( (Get-Item $FilePath) -isnot [System.IO.DirectoryInfo]){
        $folderPath = Split-Path -Path $FilePath
    }

    explorer.exe $folderPath
}

Set-Alias GetFolder Get-PathToFolder
function Get-PathToFolder
{
    param ([string]$FilePath )
    _checkParam $FilePath "Please provide a file path to use this command"

    $folderPath = $FilePath

    if( (Get-Item $FilePath) -isnot [System.IO.DirectoryInfo] ){
        $folderPath = Split-Path -Path $FilePath
    }

    return $folderPath
}

function GitW {
    param ([Parameter()] [string] $RemoteName = "origin" )

    _ValidateFolderHasGitRemote

    $repoUrl = _getGitRemoteURL $RemoteName

    # Start-Process chrome $repoUrl
    Start-Process $repoUrl
}

function gitc {
    param ([Parameter()] [string] $Message)

    _ValidateFolderHasGitRemote

    git add .
    git commit -m "$message"
    git push
}

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

Set-Alias gitignore Add-GitIgnoreFile
function Add-GitIgnoreFile {

    if((Test-Path .\.git -PathType Container) -eq $false)
    {
        Write-Warning ' No git repo in this directory. Try git init instead or navigate to root git folder'
        Write-Output '' 
    }
    
    Write-Output "Creating .gitignore file from https://github.com/github/gitignore/blob/main/VisualStudio.gitignore"

    Invoke-WebRequest -Uri https://raw.githubusercontent.com/github/gitignore/main/VisualStudio.gitignore -OutFile .\.gitignore
}

Set-Alias gitinit Initialize-GitRepo
function Initialize-GitRepo {

    if(Test-Path .\.git -PathType Container)
    {
        Write-Output 'Git repo already exists'
        break
    }

    git init
    Create-GitIgnoreFile
    git add .
    git commit -m "initial commit"

}

function _ValidateFolderHasGitRemote
{
    param ( [Parameter()] [string] $remoteName = "origin")
    $repoUrl = _getGitRemoteURL $remoteName

    if(!$repoUrl)
    {
        Write-Output "No git URL found"
        break
    }
}

function _getGitRemoteURL{
    param ( [Parameter()] [string] $remoteName = "origin")

    $remote = 'remote.' + $remoteName + '.url'

    $repoUrl = git config --get $remote
    return $repoUrl
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