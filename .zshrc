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
