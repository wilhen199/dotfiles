# 🚀 Dotfiles de Windows - Restauración y Configuración

## Personalización de Windows Terminal con Oh My Posh

Esta guía te mostrará cómo personalizar tu Windows Terminal con Oh My Posh, una herramienta que te permite tener un prompt más atractivo y funcional.

## 📌 Pre-requisitos

Antes de restaurar los dotfiles, asegúrate de instalar las siguientes herramientas:

🖥 Windows:

1. [Windows Terminal](https://www.microsoft.com/es-es/p/windows-terminal/9n0dx20hk701) Instalar desde Microsoft Store.
2. [PowerShell 7 o superior](https://learn.microsoft.com/es-es/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3) Instalar desde Microsoft Store. (opcional, pero recomendado).
3. [Nerd Fonts](https://www.nerdfonts.com/) (Mononoki Nerd Font Mono).
4. [Oh My Posh](https://ohmyposh.dev/docs/) (Usando `winget`)
   ```bash
   winget install JanDeDobbeleer.OhMyPosh -s winget
   ```

## 📂 Restauración de Dotfiles

1️⃣ **Clonar el repositorio**:

```bash
git clone https://github.com/wilhen199/dotfiles/tree/windows ~/dotfiles
```

2️⃣ **Ubicar PROFILE de PowerShell**:

```powershell
notepad $PROFILE
```

3️⃣ **Restaurar la configuración de Windows Terminal**: Copia el contenido de `PS_Profile` y lo pegas en el archivo recien abierto

```powershell
Import-Module -Name Terminal-Icons
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/WF.omp.json" | Invoke-Expression
```

---

## 🖼 Capturas de Pantalla

Aquí hay una vista previa de cómo debería verse la configuración después de la restauración:

![Windows Terminal](../main/img/Windows_Terminal.jpg)

---

## 📢 Notas Adicionales

- Puedes personalizar aún más tu prompt editando el archivo de configuración del tema (`.omp.json`).
- Oh My Posh también te permite usar segmentos personalizados para mostrar información adicional en tu prompt.
- Consulta la [documentación de Oh My Posh](https://ohmyposh.dev/docs/) para obtener más información.

  ✍️ **Wilhen | [GitHub](https://github.com/wilhen199) | [LinkedIn](https://www.linkedin.com/in/wilhen-figueredo/)**
