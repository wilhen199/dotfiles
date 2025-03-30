#!/bin/bash

# Configuración
REPO_URL="https://github.com/wilhen199/dotfiles.git"
REPO_PATH="$HOME/dotfiles"
BRANCH="linux"

# Archivo de respaldo de Tilix
TILIX_BACKUP="$REPO_PATH/tilix/tilix_backup.conf"

# Clonar o actualizar el repo
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "⏳ Clonando repositorio..."
    git clone "$REPO_URL" "$REPO_PATH"
else
    echo "🔄 Actualizando repositorio..."
    cd "$REPO_PATH" || exit
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
fi

# Respaldo de configuración de Tilix
echo "💾 Guardando configuración de Tilix..."
dconf dump /com/gexperts/Tilix/ > "$TILIX_BACKUP"
echo "✅ Configuración de Tilix guardada en $TILIX_BACKUP"

# Subir cambios si hay modificaciones
cd "$REPO_PATH" || exit
if [ -n "$(git status --porcelain)" ]; then
    echo "🔄 Subiendo cambios a GitHub..."
    git add .
    git commit -m "🔄 Sincronización automática $(date +'%Y-%m-%d %H:%M')"
    git push origin "$BRANCH"
    echo "✅ Dotfiles sincronizados y subidos a GitHub"
else
    echo "✅ No hay cambios nuevos"
fi
