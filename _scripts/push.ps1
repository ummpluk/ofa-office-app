Set-Location "C:\Users\ASUS\Desktop\ONEFORALL"

# Remove stale lock
if (Test-Path ".git\index.lock") {
    Remove-Item ".git\index.lock" -Force
    Write-Host "Removed index.lock"
}

# Stash changes, pull, unstash
Write-Host "Syncing with GitHub..."
git stash
git fetch origin
git merge origin/main --no-edit
git stash pop

# Copy HTML using filesystem search (avoids encoding issue)
Write-Host "Copying HTML..."
$src = Get-ChildItem -Path "DOC" -Recurse -Filter "OneForAll_Online.html" | Select-Object -First 1
$dest = Get-ChildItem -Path "DOC" -Recurse -Filter "index.html" | Where-Object { $_.FullName -like "*ofa-hosting*public*" } | Select-Object -First 1

if ($src -and $dest) {
    Copy-Item $src.FullName $dest.FullName -Force
    Write-Host "Copied: $($src.FullName)"
    Write-Host "To: $($dest.FullName)"

    # Push using the found path
    $relPath = $dest.FullName.Replace("C:\Users\ASUS\Desktop\ONEFORALL\", "")
    git add $relPath
    git commit -m "update"
    git push
    Write-Host ""
    Write-Host "Done! Check: https://github.com/ummpluk/ofa-office-app/actions"
} else {
    Write-Host "ERROR: Could not find source or destination file"
    if (-not $src) { Write-Host "Missing: OneForAll_Online.html" }
    if (-not $dest) { Write-Host "Missing: ofa-hosting/public/index.html" }
}

Read-Host "Press Enter to exit"
