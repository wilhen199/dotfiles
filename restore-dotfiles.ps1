# Configuración
$repoURL = "https://github.com/wilhen199/dotfiles.git"
$repoPath = "C:\dotfiles"
$branch = "windows"

# Ubicaciones de los dotfiles
$dotfiles = @{
    "PS_profile.ps1"   = "$PROFILE"
    "WT_settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "WF.omp.json" = "$env:POSH_THEMES_PATH/WF.omp.json"
}

# Clonar o actualizar el repo
if (-Not (Test-Path $repoPath)) {
    git clone $repoURL $repoPath
}

Set-Location $repoPath
git checkout $branch
git pull origin $branch

# Restaurar archivos del repo a las ubicaciones locales
foreach ($source in $dotfiles.Keys) {
    $target = $dotfiles[$source]
    $repoFile = Join-Path $repoPath $source

    if (Test-Path $repoFile) {
        Copy-Item -Path $repoFile -Destination $target -Force
        Write-Host "✅ Restaurado: $repoFile → $target"
    }
    else {
        Write-Host "⚠️ Advertencia: No se encontró $repoFile en el repo"
    }
}

Write-Host "✅ Restauración de dotfiles completada."
