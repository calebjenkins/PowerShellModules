
### Private Functions _ ##
function _checkParam {
    param (
        [Parameter()] [string] $Value,
        [Parameter()] [string] $ErrorMessage = "Please provide a value"
    )

    if ( (!$Value) -or ($Value -eq '') ) {
        break
    }
}

function _argsToString {
    $stringArray = ''

    foreach ($param in $args) {
        $stringArray = $stringArray + ' ' + $param
    }

    return $stringArray.Trim()
}
function _checkIntValue {
    param (
        [Parameter(Mandatory = $true)] [int] $Value,
        [Parameter(Mandatory = $false)] [int] $MinValue = 0,
        [Parameter(Mandatory = $true)] [int] $MaxValue,
        [Parameter(Mandatory = $true)] [string] $ErrorMessage
    )

    if (!$Value) {
        Write-Output $ErrorMessage
        break
    }
    if ($Value -lt $MinValue) {
        Write-Output $ErrorMessage
        break
    }
    if ($Value -gt $MaxValue) {
        Write-Output $ErrorMessage
        break
    }
} 

function _checkWindows {
    if (!$IsWindows) {
        Write-Output "This function is only supported on Windows."
        break
    }
}
