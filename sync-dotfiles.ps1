# Configuración
$repoURL = "https://github.com/wilhen199/dotfiles.git"
$repoPath = "C:\dotfiles"
$branch = "windows"

# Ubicaciones de los dotfiles
$dotfiles = @{
    "PS_profile.ps1"         = "$PROFILE"
    "WT_settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
}

# Clonar o actualizar el repo
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
        Write-Host "✅ Copiado: $source → $target"
    }
    else {
        Write-Host "⚠️ Advertencia: No se encontró $source"
    }
}

# Subir cambios automáticamente
$changes = git status --porcelain
if ($changes) {
    git add .
    git commit -m "🔄 Sincronización automática $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin $branch
    Write-Host "✅ Dotfiles sincronizados y subidos a GitHub"
}
else {
    Write-Host "✅ No hay cambios nuevos"
}
