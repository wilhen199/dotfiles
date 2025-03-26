# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME:/usr/local/bin:$PATH
export PATH=/bin:/usr/bin:/usr/local/bin:${PATH}

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerline"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git web-search)

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

source /usr/share/zsh-sudo/sudo.plugin.zsh

source /usr/share/zsh/plugins/zsh-copydir/copydir.plugin.zsh

source /usr/share/zsh/plugins/zsh-copyfile/copyfile.plugin.zsh

source $ZSH/oh-my-zsh.sh

source /opt/azure-cli/az.completion
#source /usr/share/zsh/plugins/azure-cli/az.completation

source ~/.oh-my-zsh/custom/plugins/terraform/terraform.zsh
#source /usr/share/zsh/plugins/terraform/terraform.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nano'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nano ~/.zshrc"
alias vimzsh="vim ~/.zshrc"
alias ohmyzsh="nano ~/.oh-my-zsh"
alias ll='lsd -lh --group-dirs=first'
alias lls='lsd -lh --group-dirs=first --sort=time'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first --sort=time'
alias cat='bat'
alias powerlevel='nano ~/.p10k.zsh'
alias install='sudo pacman -S'
#alias update-paru='paru -S $(paru -Qua | awk '{print $1}')'
alias dotf="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias ..="cd .."
alias ...="cd ..."
alias df="df -h"
alias myip="hostname -i"
alias ppg="ping -c 10 8.8.8.8"
alias fortistatus="fortivpn status"
alias fortidisc="fortivpn disconnect"
alias tf="terraform"
alias tfval="terraform validate"
alias tfplan="terraform plan"
alias tfap="terraform apply"



# Functions
#function mkt(){
#	mkdir {nmap,content,exploits,scripts}
#}

function rmk(){
	scrub -p dod $1
	shred -zun 10 -v $1
}
function updater(){
	sudo pacman -Syyu
	
}
function parup(){
	package=$(paru -Qua | awk '{print $1}' | sed 's/\x1B\[[0-9;]*m//g')
	if [ -n "$package" ]; then
		echo "$package"
#		paru -S "$package" 1> /dev/null
	else
		echo "No se encontraron paquetes para instalar."
	fi
}
# Ejecutar un comando que produce salida en stdout y stderr
##resultado=$(comando)

# Verificar si hubo errores (si stderr no está vacío)
##if [ -n "$(comando 2>&1 >/dev/null)" ]; then
    ##echo "Hubo errores"
    # Aquí puedes manejar la lógica en caso de error
##else
    ##echo "No hubo errores"
    # Aquí puedes manejar la lógica cuando no hay error
##fi


function cd {
  builtin cd "$@" && ls
}

# Set 'man' colors
function man() {
    env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}

function copydir {
  emulate -L zsh
  print -n $PWD | clipcopy
#  pwd | tr -d "\r\n" | clipcopy
}



#source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme


if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
complete -C '/usr/local/bin/aws_completer' aws
