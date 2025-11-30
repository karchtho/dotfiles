# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi



# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Thème (prompt coloré)
# ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"


# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  sudo
  extract
)

# Charge Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Aliases utiles
alias ll='ls -lah'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --all'
alias ..='cd ..'
alias ...='cd ../..'
alias update-all='~/update-all.sh'
alias cat='batcat'

# Autocompletion
autoload -Uz compinit
compinit

# Couleur pour autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Syntax highlighting
source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#Path to vm creation script
export PATH="$HOME/bin/creation-vm-multipass-lamp:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/python3.14/bin:$PATH"
export PATH="/usr/local/python3.14/bin:$PATH"


# Python 3.14 aliases
alias python="python3.14"
alias pip="pip3.14"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.aliases ] && source ~/.aliases


# =============================================================================
# Dotfiles management
# =============================================================================
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# User scripts
export PATH="$HOME/bin:$PATH"
