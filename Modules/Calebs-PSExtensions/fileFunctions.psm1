
#Load Private Functions
#. './_privFunctions.ps1'

function Get-PathToFolder {
    param ([string]$FilePath )
    _checkParam $FilePath "Please provide a file path to use this command"

    $folderPath = $FilePath

    if ( (Get-Item $FilePath) -isnot [System.IO.DirectoryInfo] ) {
        $folderPath = Split-Path -Path $FilePath
    }

    return $folderPath
}
Set-Alias GetFolder Get-PathToFolder
Export-ModuleMember -Function Get-PathToFolder -Alias GetFolder

Set-Alias Rename Move-Item
Set-Alias Open Invoke-Item

Export-ModuleMember -Alias Rename, Open

## Not Used Publically (Yet) ##
function FindFile {
    param ( [string]$filePattern)
    Get-ChildItem -Recurse -Filter $filePattern
}

function DirSize {
    param ( [string]$Folder )

    # Get file count and cummulative sizes
    $files = Get-ChildItem $Folder -Recurse | Measure-Object length -Sum
    $fileCount = $files.Count
    $fileSize = $files.Sum / 1MB

    # Get directory count
    $folderCount = (Get-ChildItem $Folder -Recurse -Directory | Measure-Object).Count

    # Export Data
    [PSCustomObject]@{ "Folder" = $Folder; "SubFolderCount" = $folderCount; "FileCount" = $fileCount; "TotalSize (MB)" = $fileSize }
}


function Open-Folder {
    param ( [string]$FilePath )
    _checkParam $FilePath "Please provide a file path to use this command"

    $folderPath = $FilePath

    if ( (Get-Item $FilePath) -isnot [System.IO.DirectoryInfo]) {
        #$folderPath = ($FilePath ) Split-Path -Path $FilePath
        #$outputFile = Split-Path $FilePath -leaf
        $folderPath = Split-Path -Path $FilePath -Parent
    }

    Invoke-Item $folderPath
}

function Learn-PS {
    #    To cut or extract a specific string from another string in PowerShell, you can use several methods depending on your requirements. Here are three common approaches:

    #1. Using -split Operator#
    # The -split operator splits a string into an array based on a delimiter. You can then select the desired part.
    # Example
    $string = "Hello-World-Example"
    $result = ($string -split "-")[1]  # Extracts "World"
    Write-Output $result


    #2. Using Substring Method
    #The Substring method extracts a portion of a string based on the starting index and length.
    # Example
    $string = "HelloWorldExample"
    $result = $string.Substring(5, 5)  # Extracts "World"
    Write-Output $result


    #3. Using Regular Expressions
    #Regular expressions are powerful for extracting patterns from strings.
    # Example
    $string = "Hello [World] Example"
    if ($string -match "\[(.*?)\]") {
        $result = $matches[1]  # Extracts "World"
        Write-Output $result
    }

    # Each method has its strengths, so choose the one that best fits your specific scenario! Let me know if you'd like further clarification. 😊

}