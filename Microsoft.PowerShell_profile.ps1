# Import-Module posh-git
# Import-Module -Name Terminal-Icons

# # While editing this. Use > . $PROFILE
# # to reload current powershell profile changes



## Moving to top since we're using this on the start up. 
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

Set-Alias Theme Set-PoshTheme
function Set-PoshTheme
{
    param (
            [Parameter(Position=0)] [string]$themeName,
            [Parameter(Position=1)] [string]$source = $env:POSH_THEMES_PATH
        )

    _checkParam $themeName

    $pathToTheme = $source + "/" + $themeName + ".omp.json"

    $exists = Test-Path -Path $pathToTheme -PathType Leaf
    if ($exists -eq $false)
    {
        Write-Output "Theme not found"
        break
    }

    oh-my-posh init pwsh --config $pathToTheme | Invoke-Expression
}

## SET UP ##
# Before you can use oh-my-posh on Windows: #
# > winget install janDeDobbeleer.OhMyPosh
# > oh-my-posh font install 
$env:POSH_GIT_ENABLED = $true

# Set-PoshTheme uniForm  GetFolder($Profile)
Set-PoshTheme uniForm (GetFolder ($PROFILE))
#Set-PoshTheme unicorn


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

function GitW {
    param ([Parameter()] [string] $RemoteName = "origin" )

    _ValidateFolderHasGitRemote

    $repoUrl = _getGitRemoteURL $RemoteName
    $branch = git branch --show-current
    if($branch -NE '')
    {
        $repoUrl = $repoUrl + '/tree/' + $branch
    }

    # Start-Process chrome $repoUrl
    Start-Process $repoUrl
}

function Write-GitBranchName () {
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host " ($branch)" -ForegroundColor "red"
        }
        else {
            # we're on an actual branch, so print it
            Write-Host " ($branch)" -ForegroundColor "blue"
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host " (no branches yet)" -ForegroundColor "yellow"
    }
}

function git-prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$('>' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    if (Test-Path .git) {
        Write-Host $path -NoNewline -ForegroundColor "green"
        Write-GitBranchName
    }
    else {
        # we're not in a repo so don't bother displaying branch name/sha
        Write-Host $path -ForegroundColor "green"
    }

    return $userPrompt
}

function gitc {
    $Message = _argsToString $args
    _checkParam $Message "Please include comment text for this commit."

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

Set-Alias gitinit Initialize-GitRepo
function Initialize-GitRepo {
    param(
        [Parameter(Position=0)] [string] $IgnoreStyle = "VisualStudio"
    )

    if(_isGitRepo)
    {
        Write-Warning 'Git repo already exists'
        break
    }

    git init
    Add-GitIgnoreFile
    git add .
    git commit -m "initial commit"

}

Set-Alias gitignore Add-GitIgnoreFile
function Add-GitIgnoreFile {
    param(
        [Parameter(Position=0)] [string] $IgnoreStyle = "VisualStudio",
        [Parameter(Position=1)] [bool] $suppressWarning = $false
    )

    if((_isGitRepo -eq $false) -and ($suppressWarning -eq $true))
    {
        Write-Warning ' No git repo in this directory. Try git init instead or navigate to root git folder'
        Write-Output '' 
    }

    $ignoreFile = "https://raw.githubusercontent.com/github/gitignore/main/" + $IgnoreStyle + ".gitignore"
    Write-Output "Creating .gitignore file from https://github.com/github/gitignore/blob/main/" + $IgnoreStyle + ".gitignore"

    try {
        Invoke-WebRequest -Uri $ignoreFile -OutFile .\.gitignore    
    }
    catch {
        Write-Output 'Ignore file not found'
        Write-Host -NoNewline 'Press Enter or Y to check web resource'

        $keypress = [System.Console]::ReadKey($true)
        if(($keypress.KeyChar -eq 'Enter' ) -or ($keypress.KeyChar -eq 'Y') -or ($keypress.KeyChar -eq 'y' ))
        {
            Open-Web 'https://github.com/github/gitignore'
        }
    }
}

function _isGitRepo{
    $result = git rev-parse --is-inside-work-tree
    if($result -contains 'fatal')
    {
        $result = $false
    }

    return $result
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
    $repoUrl = $repoUrl.Trimend('.git')
    
    return $repoUrl
}


### Private Functions _ ##

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