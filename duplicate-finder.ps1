function Get-StringSimilarity {
    param (
        [string]$str1,
        [string]$str2
    )
    
    $prefixLength = 0
    $suffixLength = 0
    $minLength = [Math]::Min($str1.Length, $str2.Length)
    
    # Find matching prefix length
    for ($i = 0; $i -lt $minLength; $i++) {
        if ($str1[$i] -ne $str2[$i]) { break }
        $prefixLength++
    }
    
    # Find matching suffix length
    for ($i = 1; $i -le $minLength - $prefixLength; $i++) {
        if ($str1[$str1.Length - $i] -ne $str2[$str2.Length - $i]) { break }
        $suffixLength++
    }
    
    $totalMatch = $prefixLength + $suffixLength
    return $totalMatch / [Math]::Max($str1.Length, $str2.Length)
}

function Get-ColorFromSimilarity {
    param (
        [double]$similarity
    )
    
    if ($similarity -gt 0.9) { return "Red" }
    elseif ($similarity -gt 0.7) { return "DarkYellow" }
    elseif ($similarity -gt 0.5) { return "Yellow" }
    elseif ($similarity -gt 0.3) { return "Green" }
    else { return "White" }
}

$files = Get-ChildItem -File | ForEach-Object {
    @{
        Name = $_.Name
        BaseName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    }
}

foreach ($file1 in $files) {
    $maxSimilarity = 0
    $mostSimilarFile = $null
    
    foreach ($file2 in $files) {
        if ($file1.Name -ne $file2.Name) {
            $similarity = Get-StringSimilarity $file1.BaseName $file2.BaseName
            if ($similarity -gt $maxSimilarity) {
                $maxSimilarity = $similarity
                $mostSimilarFile = $file2.Name
            }
        }
    }
    
    $color = Get-ColorFromSimilarity $maxSimilarity
    Write-Host $file1.Name -ForegroundColor $color -NoNewline
    Write-Host " (Similar to: $mostSimilarFile - $([math]::Round($maxSimilarity * 100))% match)"
}