

function Open-Web {
    $Message = _argsToString $args
    _checkParam $Message "Please include a URL in web command."

    Start-Process $Message
}
Set-Alias web Open-Web
Export-ModuleMember -Function Open-Web -Alias web

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
 
