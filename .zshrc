# Must be set before instant prompt is sourced
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Get RDP secret file for Shipit administartion
source ~/.rdp-secrets

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

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
fpath=("$HOME/.bun" $fpath)


# Shipit Work specific
bob-audit-show-latest() {
  cat /var/log/bob-audit/rapport-$(date +%F).txt
}

  
bob-docker-images() {
  sudo -u maintainer bash -c 'grep -r "image:" /srv/*/docker-compose.yml' 2>/dev/null | awk '
    {
      split($0, a, "/")
      svc = a[3]
      sub(/.*image:[[:space:]]*/, "")
      img = $0
      if (img ~ /:latest$/ || img !~ /:/)
        printf "  [!]  %-20s %s  <- non epingle\n", svc, img
      else
        printf "  [ok] %-20s %s\n", svc, img
    }
  '
}
export DOCKER_HOST=unix:///run/docker.sock
