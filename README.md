# 🚀 Dotfiles de Linux - Restauración y Configuración

Restore a Zsh setup with **Powerlevel10k**, and a set of useful aliases, replicating this repository in minutes.

## 📑 Index

- [📌 Prerequisites](#pre-req)
- [📑 Installation](#installation)
- [🖼️ Screenshots](#screenshots)
- [📢 Notes](#-notes)

---

## 📌 Prerequisites <a id="pre-req"></a>

Before restoring the dotfiles, make sure you have the following tools installed.

1. **Git**, to clone the repository.

2. **Zsh** with [Oh My Zsh](https://ohmyz.sh/)

   ```sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

3. **Powerlevel10k** (Zsh theme)

   ```sh
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
   ```

4. **Zsh plugins and command-line tools** used by the `.zshrc`:

   | Tool | Purpose |
   | ------ | --------- |
   | `zsh-syntax-highlighting` | Syntax highlighting in the terminal |
   | `zsh-autosuggestions` | Command suggestions from history |
   | `bat` | Replacement for `cat` (alias `cat`) |
   | `lsd` | Replacement for `ls` (aliases `ls`, `ll`, `la`...) |
   | `fzf` | Interactive search (optional) |
   | `xclip` or `wl-clipboard` | Clipboard support for `copydir` and `copyfile` |
   | `conky` | System monitor (optional, used in the desktop setup) |

   Install them with your package manager:

   ```sh
   # Arch Linux
   sudo pacman -S git zsh zsh-syntax-highlighting zsh-autosuggestions bat lsd fzf xclip conky

   # Debian / Ubuntu
   sudo apt install git zsh zsh-syntax-highlighting zsh-autosuggestions bat lsd fzf xclip conky

   # Fedora
   sudo dnf install git zsh zsh-syntax-highlighting zsh-autosuggestions bat lsd fzf xclip conky
   ```

   > 💡 **Tip:** The `.zshrc` loads plugins from `/usr/share/zsh-plugins/`. If your package manager installs them somewhere else, update the `source` lines at the top of the plugins section.

[⬆️ Back to index](#-index)

   ---

## 📑 Installation <a id="installation"></a>

1️⃣ **Clone the repository** into your home directory:

```sh
git clone -b linux https://github.com/wilhen199/dotfiles.git
```

2️⃣ **Back up your existing configuration** (skip any file that does not exist):

```sh
mv ~/.zshrc ~/.zshrc.bak
mv ~/.p10k.zsh ~/.p10k.zsh.bak
```

3️⃣ **Create the symbolic links**:

```sh
# Terminal and prompt
ln -s ~/dotfiles/files/.zshrc ~/.zshrc
ln -s ~/dotfiles/files/.p10k.zsh ~/.p10k.zsh

```

4️⃣ **Restore the Tilix configuration** (optional, only if you use Tilix):

```sh
dconf load /com/gexperts/Tilix/ < ~/dotfiles/tilix/tilix_backup.conf
```

5️⃣ **Make Zsh your default shell** and apply the changes:

```sh
chsh -s "$(which zsh)"
source ~/.zshrc
```

The `.zshrc` detects your distribution automatically (Arch, Fedora, or Debian/Ubuntu) and sets the right package manager aliases: `install`, `uninstall`, and `update`.

[⬆️ Back to index](#-index)

---

## 🖼️ Screenshots <a id="screenshots"></a>

Here is a preview of how the configuration should look after the restoration:

![Terminal con Powerlevel10k](../main/img/Extendida.png)

---

## 📢 Notes

- If something does not work, check that the packages from the prerequisites are installed.
- To update the dotfiles later:

  ```sh
  cd ~/dotfiles
  git pull origin linux
  ```

- Open a new terminal or run `source ~/.zshrc` after every change to the `.zshrc`.

[⬆️ Back to index](#-index)

---
✍️ **Wilhen**

<p align="left">
  <a href="https://linkedin.com/in/wilhen-figueredo" target="_blank" rel="noopener">
    <img src="https://img.icons8.com/fluency/48/linkedin.png" alt="LinkedIn">
  </a>
  <a href="mailto:wilhen199@gmail.com">
    <img src="https://img.icons8.com/fluency/48/email.png" alt="Gmail">
  </a>
  <a href="https://wilhenfigueredo.dev" target="_blank" rel="noopener">
    <img src="https://img.icons8.com/fluency/48/resume-website.png" alt="CV-Digital">
  </a>
</p>

---