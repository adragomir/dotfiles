function prompt {
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    Write-Host " $date " -ForegroundColor White
    Write-Host "$pwd" -ForegroundColor Blue -BackgroundColor Black
    Write-Host ">" -ForegroundColor Magenta -BackgroundColor Black -NoNewLine
    return " "
} 
