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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
