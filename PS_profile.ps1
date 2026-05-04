# Oh My Posh primero
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/WF.omp.json" | Invoke-Expression

# Lazy load
function Load-TerminalIcons {
    Import-Module Terminal-Icons
}
