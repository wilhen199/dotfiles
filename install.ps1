# Require execution as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "⚠️  This script must be run as Administrator"
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 1. Install Powershell 7 with winget
write-Host "`n=== Installing PowerShell 7... ===" -ForegroundColor Cyan
winget install --id Microsoft.PowerShell --source winget
if (!(Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }

# 2. Install Oh My Posh using winget
write-Host "`n=== Installing Oh My Posh... ===" -ForegroundColor Cyan
winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements

# 3. Refresh environment to have updated PATH and POSH_THEMES_PATH in this session
function Update-SessionEnvironment {
    $machinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $userPath    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machinePath;$userPath"

    $env:POSH_THEMES_PATH = [Environment]::GetEnvironmentVariable('POSH_THEMES_PATH', 'User')
    if (-not $env:POSH_THEMES_PATH) {
        $env:POSH_THEMES_PATH = [Environment]::GetEnvironmentVariable('POSH_THEMES_PATH', 'Machine')
    }
}


# 4. Install Hack Nerd Font
write-Host "`n=== Installing Hack Nerd Font... ===" -ForegroundColor Cyan

# 4.1. Temp paths
$nameFileZip = "Hack.zip"
$pathZip = "$env:TEMP\$nameFileZip"
$folderExtr = "$env:TEMP\FontExtract_$([guid]::NewGuid())"

# 4.2. Download Hack Nerd Font
write-host "`n=== Downloading  Hack Nerd Font... ===" -ForegroundColor Yellow
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Hack.zip"

Invoke-WebRequest -Uri $fontUrl -OutFile $pathZip

# 4.3. Extract zip file
write-host "`n=== Extracting files... ===" -ForegroundColor Yellow
Expand-Archive -Path $pathZip -DestinationPath $folderExtr -Force

# 4.4. Install fonts
write-host "`n=== Installing fonts... ===" -ForegroundColor Yellow
$shell = New-Object -ComObject Shell.Application
$folderFonts = $shell.Namespace(0x14)

Get-ChildItem -Path $folderExtr -Filter "*.ttf" | ForEach-Object {
    $folderFonts.CopyHere($_.FullName, 0x10)
    Write-Host "Installed font: $_" -ForegroundColor Green
}

# 5. Oh My Posh configuration
write-Host "`n=== Setting up Oh My Posh... ===" -ForegroundColor Cyan
$dotfilesPath = "$env:USERPROFILE\dotfiles"

# ALWAYS use the PowerShell 7 profile, regardless of which host executes the script
$pwshProfilePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) "PowerShell\Microsoft.PowerShell_profile.ps1"
if (!(Test-Path $pwshProfilePath)) {
    New-Item -ItemType File -Path $pwshProfilePath -Force | Out-Null
}

$dotfiles = @{
    "PS_profile.ps1"   = $pwshProfilePath
    "WT_settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "WF.omp.json" = "$env:POSH_THEMES_PATH/WF.omp.json"
}

foreach ($source in $dotfiles.Keys) {
    $target = $dotfiles[$source]
    $repoFile = Join-Path $dotfilesPath $source

    if (Test-Path $repoFile) {
        Copy-Item -Path $repoFile -Destination $target -Force
        Write-Host "✅ Setup: $repoFile → $target"
    }
    else {
        Write-Host "⚠️ Advertencia: Not found $repoFile"
    }
}

# 6. Install Coreutils
write-Host "`n=== Installing Coreutils... ===" -ForegroundColor Cyan
winget install Microsoft.Coreutils --accept-package-agreements --accept-source-agreements

# 7. Install bat
write-Host "`n=== Installing bat... ===" -ForegroundColor Cyan
winget install sharkdp.bat --accept-package-agreements --accept-source-agreements

# 8. Install lsd
write-Host "`n=== Installing lsd... ===" -ForegroundColor Cyan
winget install -e --id lsd-rs.lsd --accept-package-agreements --accept-source-agreements

# 9. Install fzf (binary)
write-Host "`n=== Installing fzf... ===" -ForegroundColor Cyan
winget install -e --id junegunn.fzf --accept-package-agreements --accept-source-agreements

# 10. Install PowerShell modules (PSFzf, Terminal-Icons)
write-Host "`n=== Installing PowerShell modules... ===" -ForegroundColor Cyan

if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
}

# Marcar PSGallery como confiable para evitar prompts interactivos
if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

$modules = @("PSFzf", "Terminal-Icons")
foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "Installing module: $module" -ForegroundColor Yellow
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
    } else {
        Write-Host "Module already installed: $module" -ForegroundColor Green
    }
}

# 11. Clean up temp files
Remove-Item $pathZip -Force
Remove-Item $folderExtr -Recurse -Force

# 12. Verification
Write-Host "`n=== Verification ===" -ForegroundColor Cyan
Get-Command bat, lsd, fzf -ErrorAction SilentlyContinue | Select-Object Name, Source
Get-Module -ListAvailable PSFzf, Terminal-Icons | Select-Object Name, Version
Test-Path "$env:POSH_THEMES_PATH\WF.omp.json"

Write-Host "`n=== Installation completed ===" -ForegroundColor Cyan
Write-Host "1. Oh My Posh has been installed successfully." -ForegroundColor Yellow
Write-Host "2. Hack Nerd Font has been installed." -ForegroundColor Yellow
Write-Host "3. The PowerShell profile has been configured." -ForegroundColor Yellow
Write-Host "4. Windows Terminal has been customized." -ForegroundColor Yellow
Write-Host "5. Useful tools have been installed (bat, lsd, fzf)." -ForegroundColor Yellow
Write-Host "`nPlease close and reopen Windows Terminal to see the changes." -ForegroundColor Yellow
Write-Host "In the new terminal, select 'Custom PowerShell' and configure the Hack Nerd Font in the settings." -ForegroundColor Yellow