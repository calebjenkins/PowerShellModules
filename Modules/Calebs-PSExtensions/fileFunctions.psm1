
#Load Private Functions
#. './_privFunctions.ps1'

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
Set-Alias GetFolder Get-PathToFolder

Set-Alias Rename Move-Item
Set-Alias Open Invoke-Item

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

    Invoke-Item $folderPath
}