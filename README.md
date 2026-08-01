# 🚀 Dotfiles de Windows - Restauración y Configuración

Personaliza tu Windows Terminal con **Oh My Posh** para tener un prompt más atractivo y funcional, replicando la configuración de este repositorio en minutos.

---

## 📑 Tabla de Contenidos

- [📌 Pre-requisitos](#pre-requisitos)
- [¿Qué tipo de instalación quieres?](#que-tipo-de-instalacion-quieres)
  - [📂 Instalación Manual](#instalacion-manual)
  - [📂 Instalación Automática](#instalacion-automatica)
- [🖼 Capturas de Pantalla](#capturas-de-pantalla)
- [📢 Notas Adicionales](#notas-adicionales)

---

## 📌 Pre-requisitos <a id="pre-requisitos"></a>

Antes de restaurar los dotfiles, asegúrate de instalar las siguientes herramientas:

🖥 Windows:

1. [Windows Terminal](https://www.microsoft.com/es-es/p/windows-terminal/9n0dx20hk701) Instalar desde Microsoft Store.
2. [PowerShell 7 o superior](https://learn.microsoft.com/es-es/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3)
   ```bash
   winget install --id Microsoft.PowerShell --source winget
   ```
3. [Nerd Fonts](https://www.nerdfonts.com/font-downloads) (Hack Nerd Font).
4. [Oh My Posh](https://ohmyposh.dev/docs/) (Usando `winget`)
   ```bash
   winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
   ```

> 💡 **Tip:** si al ejecutar `install.ps1` te aparece un error de política de ejecución, corre PowerShell como Administrador y ejecuta:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

---

## 📑 ¿Qué tipo de instalación quieres? <a id="que-tipo-de-instalacion-quieres"></a>

- 🖐️ [Instalación Manual](#instalacion-manual) — control total, paso a paso.
- ⚡ [Instalación Automática](#instalacion-automatica) — un script hace todo por ti.

---

### 📂 Instalación Manual <a id="instalacion-manual"></a>

1️⃣ **Clonar el repositorio**:

```bash
git clone -b windows https://github.com/wilhen199/dotfiles.git dotfiles
```

2️⃣ **Ubicar PROFILE de PowerShell**:

```powershell
notepad $PROFILE
```

3️⃣ **Restaurar la configuración de Windows Terminal**:

Copia el contenido de `PS_Profile` y pégalo en el archivo recién abierto:

```powershell
Import-Module -Name Terminal-Icons
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/WF.omp.json" | Invoke-Expression
```

[⬆️ Volver a la tabla de contenidos](#-tabla-de-contenidos)

---

### 📂 Instalación Automática <a id="instalacion-automatica"></a>

**1️⃣ Clonar el repositorio**

```bash
git clone -b windows https://github.com/wilhen199/dotfiles.git dotfiles
```

**2️⃣ Entrar a la carpeta `dotfiles` y ejecutar `install.ps1` con PowerShell 7 o superior como Administrador**

El script instalará automáticamente:
- [Oh My Posh](https://ohmyposh.dev/docs/)
- Fuente [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)
- [Microsoft.Coreutils](https://learn.microsoft.com/eu-es/windows/core-utils/overview)
- `bat` - es como un `cat` pero con esteroides 😂
- `lsd` - es como `ls` pero con esteroides 😂
- `fzf` - buscador interactivo en la terminal

[⬆️ Volver a la tabla de contenidos](#-tabla-de-contenidos)

---

## 🖼 Capturas de Pantalla <a id="capturas-de-pantalla"></a>

Aquí hay una vista previa de cómo debería verse la configuración después de la restauración:

![Windows Terminal](https://raw.githubusercontent.com/wilhen199/dotfiles/main/img/Windows_Terminal.png)

---

## 📢 Notas Adicionales

- Puedes personalizar aún más tu prompt editando el archivo de configuración del tema (`.omp.json`).
- Oh My Posh también te permite usar segmentos personalizados para mostrar información adicional en tu prompt.
- Consulta la [documentación de Oh My Posh](https://ohmyposh.dev/docs/) para profundizar más.

---

✍️ **Wilhen | [GitHub](https://github.com/wilhen199) | [LinkedIn](https://www.linkedin.com/in/wilhen-figueredo/)**
