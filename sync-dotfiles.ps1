# Configuración
$repoURL = "https://github.com/wilhen199/dotfiles.git"
$repoPath = "C:\Users\wfigueredoh\OneDrive - Falabella\dotfiles"
$branch = "windows"

# Ubicaciones de los dotfiles
$dotfiles = @{
    "PowerShell_profile.ps1" = "$PROFILE"
    "windows_terminal_settings.json" = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
}

# Clonar o actualizar el repo
if (-Not (Test-Path $repoPath)) {
    git clone $repoURL $repoPath
}

Set-Location $repoPath
git checkout $branch
git pull origin $branch

# Crear Symlinks
foreach ($file in $dotfiles.Keys) {
    $source = "$repoPath\$file"
    $target = $dotfiles[$file]

    if (Test-Path $target) { Remove-Item $target -Force }
    New-Item -ItemType SymbolicLink -Path $target -Target $source
    Write-Host "🔗 Vinculado: $source → $target"
}

# Subir cambios automáticamente
$changes = git status --porcelain
if ($changes) {
    git add .
    git commit -m "🔄 Sincronización automática $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin $branch
    Write-Host "✅ Dotfiles sincronizados y subidos a GitHub"
} else {
    Write-Host "✅ No hay cambios nuevos"
}
