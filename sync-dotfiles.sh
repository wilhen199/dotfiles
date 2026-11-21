#!/bin/zsh

# Configuration
REPO_URL="https://github.com/wilhen199/dotfiles.git"
REPO_PATH="$HOME/dotfiles"
BRANCH="linux"

# Tilix backup
TILIX_BACKUP="$REPO_PATH/tilix/tilix_backup.conf"

# Clone and update
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "⏳ Cloning repository..."
    git clone "$REPO_URL" "$REPO_PATH"
else
    echo "🔄 Actualizando repositorio..."
    cd "$REPO_PATH" || exit
    git checkout "$BRANCH"
    git pull origin "$BRANCH"
fi

# Backup Tilix configuration
echo "💾 Saving Tilix configuration..."
dconf dump /com/gexperts/Tilix/ > "$TILIX_BACKUP"
echo "✅ Saved Tilix configuration in $TILIX_BACKUP"

# Subir cambios si hay modificaciones
cd "$REPO_PATH" || exit
if [ -n "$(git status --porcelain)" ]; then
    echo "🔄 Uploading change to  GitHub..."
    git add .
    git commit -m "🔄 Automatic sync $(date +'%Y-%m-%d %H:%M')"
    git push origin "$BRANCH"
    echo "✅ Dotfiles synced and pushed to GitHub"
else
    echo "✅ No new changes"
fi
