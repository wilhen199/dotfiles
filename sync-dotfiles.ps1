# Configuration
$repoURL = "https://github.com/wilhen199/dotfiles.git"
$repoPath = "$env:USERPROFILE\dotfiles"
$branch = "windows"

# Dotfiles locations
$dotfiles = @{
    "$PROFILE"                                                                                    = "PS_profile.ps1"
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "WT_settings.json"
    "$env:POSH_THEMES_PATH/WF.omp.json" = "WF.omp.json"
}

# Clone or update the repo
if (-Not (Test-Path $repoPath)) {
    git clone $repoURL $repoPath
}

Set-Location $repoPath
git checkout $branch
git pull origin $branch

# Copiar archivos al repo
foreach ($source in $dotfiles.Keys) {
    $target = $dotfiles[$source]

    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $target -Force
        Write-Host "✅ Copied: $source → $target"
    }
    else {
        Write-Host "⚠️ Warning: $source not found"
    }
}

# Push changes automatically
$changes = git status --porcelain
if ($changes) {
    git add .
    git commit -m "🔄 Automatic sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin $branch
    Write-Host "✅ Dotfiles synced and pushed to GitHub"
}
else {
    Write-Host "✅ No new changes"
}
