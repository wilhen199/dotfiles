# Configuration
$repoURL = "https://github.com/wilhen199/dotfiles.git"
$repoPath = "$env:USERPROFILE\dotfiles"
$branch = "windows"

# Dotfiles locations
$dotfiles = @{
    "PS_profile.ps1"   = "$PROFILE"
    "WT_settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "WF.omp.json" = "$env:POSH_THEMES_PATH/WF.omp.json"
}

# Clone or update the repo
if (-Not (Test-Path $repoPath)) {
    git clone $repoURL $repoPath
}

Set-Location $repoPath
git checkout $branch
git pull origin $branch

# Restore files from the repo to local locations
foreach ($source in $dotfiles.Keys) {
    $target = $dotfiles[$source]
    $repoFile = Join-Path $repoPath $source

    if (Test-Path $repoFile) {
        Copy-Item -Path $repoFile -Destination $target -Force
        Write-Host "✅ Restored: $repoFile → $target"
    }
    else {
        Write-Host "⚠️ Warning: $repoFile not found in the repo"
    }
}

Write-Host "✅ Dotfiles restoration completed."
