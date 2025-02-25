$filemask = Read-Host "What string are we moving (use wildcards)"
$subname = Read-Host "Name of new Subfolder"
$files = Get-ChildItem -file -recurse *$filemask*

# process files one by one
foreach ($file in $files)
{
    # adding subfoldername to path
    $destinationfolderpath = $file.directoryname + "\" + $subname + "\"

    # creating subfolder
    New-Item $destinationfolderpath >$null -ItemType Directory -Force

    # move the file to subfolder
    move-item $file -Destination $destinationfolderpath

    Write-Host "Moved $file to $destinationfolderpath"

}