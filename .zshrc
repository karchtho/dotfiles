# Must be set before instant prompt is sourced
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Main Zsh configuration with platform detection
# Sources platform-specific configuration files based on OS

# Detect OS and source appropriate configuration
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  [ -f ~/.zshrc.macos ] && source ~/.zshrc.macos
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux
  [ -f ~/.zshrc.linux ] && source ~/.zshrc.linux
else
  # Fallback for other Unix systems
  [ -f ~/.zshrc.linux ] && source ~/.zshrc.linux
fi

export GITLAB_HOME=/srv/gitlab

# bun completions
fpath=("$HOME/.bun" $fpath)

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude-mem='/Users/thomas/.bun/bin/bun "/Users/thomas/.claude/plugins/cache/thedotmack/claude-mem/10.6.2/scripts/worker-service.cjs"'


