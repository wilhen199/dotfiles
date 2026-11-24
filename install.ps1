# ============================================================
# Prerequisite: PowerShell 7 must be installed.
# Run this script with: pwsh -File .\setup.ps1
# ============================================================

# 1. Require PowerShell 7 (Core edition)
if ($PSVersionTable.PSEdition -ne 'Core') {
    Write-Warning "⚠️  This script requires PowerShell 7. Run it with: pwsh -File `"$PSCommandPath`""
    exit 1
}

# 2. Require execution as Administrator (no auto-elevation)
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "⚠️  This script must be run as Administrator."
    Write-Host "Please open PowerShell 7 as Administrator and run this script again:" -ForegroundColor Yellow
    Write-Host "  pwsh -File `"$PSCommandPath`"" -ForegroundColor Yellow
    exit 1
}

# 3. Refresh environment variables in this session
function Update-SessionEnvironment {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"

    $env:POSH_THEMES_PATH = [Environment]::GetEnvironmentVariable('POSH_THEMES_PATH', 'User')
    if (-not $env:POSH_THEMES_PATH) {
        $env:POSH_THEMES_PATH = [Environment]::GetEnvironmentVariable('POSH_THEMES_PATH', 'Machine')
    }
}

# 4. Install Git if it is missing (needed to clone the repo)
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "`n=== Installing Git... ===" -ForegroundColor Cyan
    winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements
    Update-SessionEnvironment
}

# 5. Clone the dotfiles repo if it is not already on this machine
$repoURL = "https://github.com/wilhen199/dotfiles.git"
$dotfilesPath = "$env:USERPROFILE\dotfiles"
$branch = "windows"

if (-not (Test-Path "$dotfilesPath\WF.omp.json")) {
    Write-Host "`n=== Cloning dotfiles repo... ===" -ForegroundColor Cyan
    git clone -b $branch $repoURL $dotfilesPath
}

# 6. Install Oh My Posh using winget
Write-Host "`n=== Installing Oh My Posh... ===" -ForegroundColor Cyan
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
Update-SessionEnvironment

# 7. Prepare the themes folder and the POSH_THEMES_PATH variable
$themesDir = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes"

if (-not (Test-Path $themesDir)) {
    Write-Host "`n=== Downloading Oh My Posh themes... ===" -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
    $themesZip = "$env:TEMP\oh-my-posh-themes.zip"
    Invoke-WebRequest -Uri "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" -OutFile $themesZip
    Expand-Archive -Path $themesZip -DestinationPath $themesDir -Force
    Remove-Item $themesZip -Force
}

if (-not [Environment]::GetEnvironmentVariable('POSH_THEMES_PATH', 'User')) {
    [Environment]::SetEnvironmentVariable('POSH_THEMES_PATH', $themesDir, 'User')
}
Update-SessionEnvironment
if (-not $env:POSH_THEMES_PATH) { $env:POSH_THEMES_PATH = $themesDir }

# 8. Create the PowerShell profile if it does not exist
if (!(Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force | Out-Null }

# 9. Install Hack Nerd Font
Write-Host "`n=== Installing Hack Nerd Font... ===" -ForegroundColor Cyan

$pathZip = "$env:TEMP\Hack.zip"
$folderExtr = "$env:TEMP\FontExtract_$([guid]::NewGuid())"

$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip"
Invoke-WebRequest -Uri $fontUrl -OutFile $pathZip
Expand-Archive -Path $pathZip -DestinationPath $folderExtr -Force

$shell = New-Object -ComObject Shell.Application
$folderFonts = $shell.Namespace(0x14)

Get-ChildItem -Path $folderExtr -Filter "*.ttf" | ForEach-Object {
    $folderFonts.CopyHere($_.FullName, 0x10)
    Write-Host "Installed font: $($_.Name)" -ForegroundColor Green
}

# 10. Copy dotfiles from the repo to this machine
Write-Host "`n=== Setting up dotfiles... ===" -ForegroundColor Cyan

$dotfiles = @{
    "PS_profile.ps1"   = $PROFILE
    "WT_settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "WF.omp.json"      = "$themesDir\WF.omp.json"
}

foreach ($source in $dotfiles.Keys) {
    $target = $dotfiles[$source]
    $repoFile = Join-Path $dotfilesPath $source

    if (Test-Path $repoFile) {
        $targetDir = Split-Path $target
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        Copy-Item -Path $repoFile -Destination $target -Force
        Write-Host "✅ Setup: $repoFile → $target" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️ Warning: Not found $repoFile" -ForegroundColor Yellow
    }
}

# 11. Install Coreutils, bat, lsd, fzf
Write-Host "`n=== Installing Coreutils... ===" -ForegroundColor Cyan
winget install Microsoft.Coreutils --accept-package-agreements --accept-source-agreements

Write-Host "`n=== Installing bat... ===" -ForegroundColor Cyan
winget install sharkdp.bat --accept-package-agreements --accept-source-agreements

Write-Host "`n=== Installing lsd... ===" -ForegroundColor Cyan
winget install -e --id lsd-rs.lsd --accept-package-agreements --accept-source-agreements

Write-Host "`n=== Installing fzf... ===" -ForegroundColor Cyan
winget install -e --id junegunn.fzf --accept-package-agreements --accept-source-agreements

# 12. Install PowerShell modules (PSFzf, Terminal-Icons)
Write-Host "`n=== Installing PowerShell modules... ===" -ForegroundColor Cyan

if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
}
if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

$modules = @("PSFzf", "Terminal-Icons")
foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module: $module" -ForegroundColor Yellow
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
    }
    else {
        Write-Host "Module already installed: $module" -ForegroundColor Green
    }
}

# 13. Clean up temp files
Remove-Item $pathZip -Force -ErrorAction SilentlyContinue
Remove-Item $folderExtr -Recurse -Force -ErrorAction SilentlyContinue

# 14. Verification
Write-Host "`n=== Verification ===" -ForegroundColor Cyan
Get-Command bat, lsd, fzf -ErrorAction SilentlyContinue | Select-Object Name, Source
Get-Module -ListAvailable PSFzf, Terminal-Icons | Select-Object Name, Version
Write-Host "Theme file: $themesDir\WF.omp.json -> $(Test-Path "$themesDir\WF.omp.json")"
Write-Host "POSH_THEMES_PATH: $([Environment]::GetEnvironmentVariable('POSH_THEMES_PATH', 'User'))"

Write-Host "`n=== Installation completed ===" -ForegroundColor Cyan
Write-Host "Please close and reopen Windows Terminal (both normal and as Administrator)." -ForegroundColor Yellow