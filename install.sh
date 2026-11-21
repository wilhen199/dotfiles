#!/usr/bin/env bash
#
# Bootstrap script for the Linux dotfiles.
# Installs: zsh, Oh My Zsh, Powerlevel10k, Zsh plugins, Hack Nerd Font,
# and links the .zshrc and .p10k.zsh files from the repository.
# Also configures the root user to use the same Zsh setup.
# Supported distributions: Arch Linux, Fedora, Debian and Ubuntu.
# Run it as a normal user (not as root). It will ask for sudo when needed.

set -e

REPO_URL="https://github.com/wilhen199/dotfiles.git"
REPO_PATH="$HOME/dotfiles"
REPO_BRANCH="linux"

# Directory where the .zshrc expects the Zsh plugins to be
PLUGIN_DIR="/usr/share/zsh-plugins"

# Directory where the font files will be installed
FONT_DIR="$HOME/.local/share/fonts/HackNerdFont"

# Font archives inside the repository "fonts" folder to install.
# Add more names here (for example "Agave.zip") if you need them later.
FONT_ARCHIVES=("Hack.zip")

# Function: create a symlink, backing up an existing regular file first
link_file() {
    local source_file="$1"
    local target_file="$2"

    # If the target is a real file (not a symlink), move it to a backup
    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "Backing up existing $target_file to $target_file.bak"
        mv "$target_file" "$target_file.bak"
    fi

    ln -sfn "$source_file" "$target_file"
    echo "Linked $target_file -> $source_file"
}

# 1. Detect the distribution
if [ ! -r /etc/os-release ]; then
    echo "Cannot detect the distribution: /etc/os-release not found."
    exit 1
fi

DISTRO_ID=$(. /etc/os-release && echo "$ID")
DISTRO_LIKE=$(. /etc/os-release && echo "$ID_LIKE")

echo "Detected distribution: $DISTRO_ID"

# 2. Install packages and set the plugin source paths for this distribution
if [ "$DISTRO_ID" = "arch" ] || [[ " $DISTRO_LIKE " == *" arch "* ]]; then
    echo "Installing packages with pacman..."
    sudo pacman -S --needed --noconfirm git curl zsh zsh-syntax-highlighting \
        zsh-autosuggestions bat lsd fzf xclip unzip fontconfig

    # Arch installs the plugins under /usr/share/zsh/plugins
    SYNTAX_SRC="/usr/share/zsh/plugins/zsh-syntax-highlighting"
    AUTOSUGGEST_SRC="/usr/share/zsh/plugins/zsh-autosuggestions"

elif [ "$DISTRO_ID" = "fedora" ] || [[ " $DISTRO_LIKE " == *" fedora "* ]]; then
    echo "Installing packages with dnf..."
    sudo dnf install -y git curl zsh zsh-syntax-highlighting \
        zsh-autosuggestions bat lsd fzf xclip unzip fontconfig

    # Fedora installs the plugins directly under /usr/share
    SYNTAX_SRC="/usr/share/zsh-syntax-highlighting"
    AUTOSUGGEST_SRC="/usr/share/zsh-autosuggestions"

elif [ "$DISTRO_ID" = "ubuntu" ] || [ "$DISTRO_ID" = "debian" ] || [[ " $DISTRO_LIKE " == *" debian "* ]]; then
    echo "Installing packages with apt..."
    sudo apt update
    sudo apt install -y git curl zsh zsh-syntax-highlighting \
        zsh-autosuggestions bat lsd fzf xclip unzip fontconfig

    # Debian and Ubuntu install the plugins directly under /usr/share
    SYNTAX_SRC="/usr/share/zsh-syntax-highlighting"
    AUTOSUGGEST_SRC="/usr/share/zsh-autosuggestions"

else
    echo "Unsupported distribution: $DISTRO_ID"
    exit 1
fi

# 3. On Debian and Ubuntu the bat binary is called batcat.
#    Create a "bat" command in /usr/local/bin, which is in the PATH used by the .zshrc
if [ ! -e /usr/local/bin/bat ] && command -v batcat >/dev/null 2>&1; then
    echo "Creating bat command from batcat..."
    sudo ln -sf "$(command -v batcat)" /usr/local/bin/bat
fi

# 4. Link the plugins to the paths the .zshrc expects
echo "Linking Zsh plugins into $PLUGIN_DIR..."
sudo mkdir -p "$PLUGIN_DIR"
sudo ln -sfn "$SYNTAX_SRC" "$PLUGIN_DIR/zsh-syntax-highlighting"
sudo ln -sfn "$AUTOSUGGEST_SRC" "$PLUGIN_DIR/zsh-autosuggestions"

# Plugins that are not packaged: sudo, copydir and copyfile (from Oh My Zsh)
sudo mkdir -p "$PLUGIN_DIR/zsh-sudo" "$PLUGIN_DIR/zsh-copydir" "$PLUGIN_DIR/zsh-copyfile"
sudo curl -fsSL -o "$PLUGIN_DIR/zsh-sudo/sudo.plugin.zsh" \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
sudo curl -fsSL -o "$PLUGIN_DIR/zsh-copydir/copydir.plugin.zsh" \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/copypath/copypath.plugin.zsh
sudo curl -fsSL -o "$PLUGIN_DIR/zsh-copyfile/copyfile.plugin.zsh" \
    https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/copyfile/copyfile.plugin.zsh

# 5. Install Oh My Zsh without changing .zshrc or the default shell
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# 6. Install Powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
    echo "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
else
    echo "Powerlevel10k is already installed."
fi

# 7. Install fzf
if [ ! -d "$HOME/.fzf" ]; then
    echo "Installing fzf..."
    git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
else
    echo "fzf is already installed."
fi

# 8. Clone or update the dotfiles repository
if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Cloning dotfiles repository..."
    git clone -b "$REPO_BRANCH" "$REPO_URL" "$REPO_PATH"
else
    echo "Updating dotfiles repository..."
    git -C "$REPO_PATH" checkout "$REPO_BRANCH"
    git -C "$REPO_PATH" pull --ff-only origin "$REPO_BRANCH"
fi

# 9. Install the Nerd Fonts listed in FONT_ARCHIVES from the repository
echo "Installing Nerd Fonts..."
mkdir -p "$FONT_DIR"

for archive_name in "${FONT_ARCHIVES[@]}"; do
    archive_path="$REPO_PATH/fonts/$archive_name"

    if [ ! -f "$archive_path" ]; then
        echo "Font archive not found: $archive_path"
        exit 1
    fi

    echo "Extracting $archive_name..."
    unzip -o -q "$archive_path" -d "$FONT_DIR"
done

# Count the font files that are now installed
FONT_COUNT=$(find "$FONT_DIR" -type f \( -iname "*.ttf" -o -iname "*.otf" \) | wc -l)

if [ "$FONT_COUNT" -eq 0 ]; then
    echo "No font files were extracted to $FONT_DIR"
    exit 1
fi

fc-cache -f "$HOME/.local/share/fonts"
echo "Installed $FONT_COUNT font files."

# 10. Link the configuration files (existing files are backed up)
link_file "$REPO_PATH/files/.zshrc" "$HOME/.zshrc"
link_file "$REPO_PATH/files/.p10k.zsh" "$HOME/.p10k.zsh"

# 11. Make zsh the default shell for the current user
ZSH_PATH=$(command -v zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "Changing default shell to zsh (you may be asked for your password)..."
    chsh -s "$ZSH_PATH"
fi

# 12. Give root the same Zsh setup by linking root's files to the user's files
if [ "$(id -u)" -ne 0 ]; then
    echo "Configuring root to use the same Zsh setup..."

    # Warn if root already has a real (non-symlink) directory or file in the way
    for root_item in /root/powerlevel10k /root/.oh-my-zsh /root/.p10k.zsh /root/.zshrc; do
        if [ -e "$root_item" ] && [ ! -L "$root_item" ]; then
            echo "Warning: $root_item exists and is not a symlink. Review it manually."
        fi
    done

    sudo ln -sfn "$HOME/powerlevel10k" /root/powerlevel10k
    sudo ln -sfn "$HOME/.oh-my-zsh" /root/.oh-my-zsh
    sudo ln -sfn "$HOME/.p10k.zsh" /root/.p10k.zsh
    sudo ln -sfn "$HOME/.zshrc" /root/.zshrc
    sudo ln -sfn "$HOME/.fzf" /root/.fzf
    echo "Linked root configuration to $HOME"

    # Make zsh the login shell for root if it is not already
    ROOT_SHELL=$(getent passwd root | cut -d: -f7)
    if [ "$ROOT_SHELL" != "$ZSH_PATH" ]; then
        echo "Changing root shell to zsh..."
        sudo chsh -s "$ZSH_PATH" root
    fi
else
    echo "Running as root: skipping root configuration step."
fi

echo ""
echo "Installation finished."
echo "Log out and log back in (or open a new terminal) to start using zsh."
echo "To check root, run: sudo -i"
echo "The first time, Powerlevel10k may ask you to configure the prompt."