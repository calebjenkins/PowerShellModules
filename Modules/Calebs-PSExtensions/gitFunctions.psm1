

#Load Private Functions
#. './_privFunctions.ps1'

function Open-GitRemoteUrl {
    param ([Parameter()] [string] $RemoteName = "origin" )

    _ValidateFolderHasGitRemote

    $repoUrl = _getGitRemoteURL $RemoteName
    $branch = git branch --show-current
    if($branch -NE '')
    {
        if($reportUrl -Match "bitbucket.")
        {
            $repoUrl = $repoUrl + '/browse?at=%2Fheads%2F' + $branch
        }
        if($reportUrl -Match "github.com")
        {
            $repoUrl = $repoUrl + '/tree/' + $branch
        }
    }

    # Start-Process chrome $repoUrl
    Start-Process $repoUrl
}
Set-Alias gitw Open-GitRemoteUrl
Export-ModuleMember -Function Open-GitRemoteUrl -Alias gitw


function _gitGetConfigValue {
    param (
        [Parameter()] [string] $key
    )

    $value = git config --global --get $key
    return $value
}

function _gitSetConfigValue {
    param (
        [Parameter()] [string] $key,
        [Parameter()] [string] $value
    )

    _checkParam $key "Please provide a key to set in git config"
    _checkParam $value "Please provide a value to set in git config"

    git config --global $key $value
}

function _gitCheckConfigValue {
    param (
        [Parameter()] [string] $key
    )

    _checkParam $key "Please provide a key to set in git config"

    $currentValue = _gitGetConfigValue $key
    if( !$currentValue )
    {
        Write-Output "Enter a value for $key :"
        $value = Read-Host
        _gitSetConfigValue $key $value
    }
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

    Write-Output "Git Directory Initialized and .gitignore added 🚀"

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

function Get-GitClone {
    param (
        [Parameter()] [string] $url
    )

    _checkParam $url "Please provide a git url to clone"

    git clone $url
}
Export-ModuleMember -Function Get-GitClone
Set-Alias -Name clone -Value Get-GitClone

