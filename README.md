# 🪟 Windows dotfiles - Restore and configuration

Customize your Windows Terminal with **Oh My Posh** for a more attractive and functional prompt, replicating the configuration of this repository in minutes.

---

## 📑 Index

- [📌 Pre-requierements](#pre-requierements)
- [What kind of instalation do you want?](#what-installation)
  - [📂 Manual](#manual)
  - [📂 Automated](#auto)
- [🖼️ Screenshots](#screenshots)
- [📢 Notes](#-notes)

---

## 📌 Pre-requisitos <a id="pre-requierements"></a>

Before restore dotfiles, ensure you have the following tools installed:

1. [Windows Terminal](https://www.microsoft.com/es-es/p/windows-terminal/9n0dx20hk701) Install from Microsoft Store.

2. [PowerShell 7 or higher](https://learn.microsoft.com/es-es/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3)

   ```bash
   winget install --id Microsoft.PowerShell --source winget
   ```

3. [Nerd Fonts](https://www.nerdfonts.com/font-downloads) (Hack Nerd Font).

4. [Oh My Posh](https://ohmyposh.dev/docs/) (Using`winget`)

   ```bash
   winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
   ```

> 💡 **Tip:** If `install.ps1` shows an error when you run it, try to run it with elevated privileges:

 ```powershell
 Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
 ```

---

## 📑 What kind of installation do you want? <a id="what-installation"></a>

- 🖐️ [Manual](#manual) — total control, step by step (only visual configurations).
- ⚡ [Automated](#auto) — script that install dependencies and configuration, everything in one go.

---

### 📂 Manual Installation <a id="manual"></a>

1️⃣ **Clone the repository**:

```bash
git clone -b windows https://github.com/wilhen199/dotfiles.git dotfiles
```

2️⃣ **Get PowerShell PROFILE**:

```powershell
notepad $PROFILE
```

3️⃣ **Restore Windows Terminal configuration**:

Copy the content of  `PS_Profile` and paste into the newly opened file (step 1):

```powershell
Import-Module -Name Terminal-Icons
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/WF.omp.json" | Invoke-Expression
```

[⬆️ Back to index](#-index)

---

### 📂 Automated installation <a id="auto"></a>

**1️⃣ Clone the repository**

```bash
git clone -b windows https://github.com/wilhen199/dotfiles.git dotfiles
```

**2️⃣ Enter the `dotfiles` folder and run `install.ps1` using PowerShell 7 or higher as an Administrator**

Script will install:

- [Oh My Posh](https://ohmyposh.dev/docs/)
- Font [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)
- [Microsoft.Coreutils](https://learn.microsoft.com/eu-es/windows/core-utils/overview)
- `bat` - it's like `cat` but on steroids 😂
- `lsd` - it's like `ls` but on steroids 😂
- `fzf` - interactive search in the terminal

[⬆️ Back to index](#-index)

---

## 🖼️ Screenshots <a id="screenshots"></a>

Here is a preview of how the configuration should look after the restoration:

![Windows Terminal](https://raw.githubusercontent.com/wilhen199/dotfiles/main/img/Windows_Terminal.png)

---

## 📢 Notes

- You can further customize your prompt by editing the theme configuration file (`.omp.json`).
- Oh My Posh also allows to use custom segments to display additional information in your prompt.
- Check [Oh My Posh docs](https://ohmyposh.dev/docs/) para learn more.

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
