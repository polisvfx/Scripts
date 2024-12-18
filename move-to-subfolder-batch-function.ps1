param(
   [Parameter(Mandatory=$true)]
   [string]$FileMask,
   
   [Parameter(Mandatory=$true)]
   [string]$FolderName,
   
   [Parameter(Mandatory=$false)]
   [string]$Exclude
)

$files = if ($Exclude) {
   Get-ChildItem -file -recurse $FileMask | Where-Object { $_.Name -notlike $Exclude }
} else {
   Get-ChildItem -file -recurse $FileMask
}

foreach ($file in $files) {
   $destinationfolderpath = $file.directoryname + "\" + $FolderName + "\"
   New-Item $destinationfolderpath >$null -ItemType Directory -Force
   move-item $file -Destination $destinationfolderpath
   Write-Host "Moved $file to $destinationfolderpath"
}