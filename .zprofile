# Platform-specific initialization

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS - Initialize Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
