############################################################################################
#    SYNC: Copies dotfiles FROM this local machine to the repo, then commits and pushes.
#    Run this after you change a config file locally and want to save that change to GitHub.
############################################################################################

# Configuration
$repoURL = "https://github.com/wilhen199/dotfiles.git"
$repoPath = "$env:USERPROFILE\dotfiles"
$branch = "windows"

### Dotfiles locations
###$dotfiles = @{
###    "$PROFILE"                                                                                    = "PS_profile.ps1"
###    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "WT_settings.json"
###    "$env:POSH_THEMES_PATH/WF.omp.json"                                                           = "WF.omp.json"
###}

# Find the Oh My Posh themes folder
if ($env:POSH_THEMES_PATH) {
    $themesDir = $env:POSH_THEMES_PATH
}
else {
    $themesDir = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes"
}

# Local file (key) -> file name in the repo (value)
$dotfiles = @{
    $PROFILE                                                                                      = "PS_profile.ps1"
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "WT_settings.json"
    (Join-Path $themesDir "WF.omp.json")                                                          = "WF.omp.json"
}

# Clone or update the repo
if (-Not (Test-Path $repoPath)) {
    git clone $repoURL $repoPath
}

Set-Location $repoPath
git checkout $branch
git pull origin $branch

# Copy files into repo
foreach ($source in $dotfiles.Keys) {
    $target = $dotfiles[$source]
    $repoFile = Join-Path $repoPath $target

    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $repoFile -Force
        Write-Host "✅ Copied: $source → $repoFile"
    }
    else {
        Write-Host "⚠️ Warning: $source not found"
    }
}

# Push changes automatically
$changes = git status --porcelain
if ($changes) {
    Write-Host "`nChanges detected:" -ForegroundColor Cyan
    git status --short
    git diff --stat

    $answer = Read-Host "`nPush these changes to GitHub? (y/n)"
    if ($answer.Trim().ToLower() -in @("s", "y")) {
        git add .
        git commit -m "🔄 Automatic sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        git push origin $branch
        Write-Host "✅ Dotfiles synced and pushed to GitHub" -ForegroundColor Green
    }
    else {
        Write-Host "⏸️ Copied to the repo but not pushed. Run the script again to push." -ForegroundColor Yellow
    }
}
else {
    Write-Host "✅ No new changes"
}
