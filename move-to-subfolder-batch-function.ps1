param(
   [Parameter(Mandatory=$true)]
   [string]$m,
   
   [Parameter(Mandatory=$true)]
   [string]$t,
   
   [Parameter(Mandatory=$false)]
   [string]$x
)

$files = if ($x) {
   Get-ChildItem -file -recurse $m | Where-Object { $_.Name -notlike $x }
} else {
   Get-ChildItem -file -recurse $m
}

foreach ($file in $files) {
   $destinationfolderpath = $file.directoryname + "\" + $t + "\"
   New-Item $destinationfolderpath >$null -ItemType Directory -Force
   move-item $file -Destination $destinationfolderpath
   Write-Host "Moved $file to $destinationfolderpath"
}