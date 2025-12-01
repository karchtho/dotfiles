#!/bin/bash

echo "🚀 Setting up Zsh + Oh My Zsh + Powerlevel10k"
echo "=============================================="

# [1/5] Install dependencies
echo "[1/5] Installing zsh, git, curl..."
sudo apt update -qq
sudo apt install -y zsh git curl > /dev/null 2>&1

# [2/5] Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[2/5] Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1
else
    echo "[2/5] Oh My Zsh already installed, skipping..."
fi

# [3/5] Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "[3/5] Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" > /dev/null 2>&1
else
    echo "[3/5] Powerlevel10k already installed, skipping..."
fi

# [4/5] Install zsh plugins
echo "[4/5] Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" 2>/dev/null || echo "  zsh-autosuggestions already installed"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" 2>/dev/null || echo "  zsh-syntax-highlighting already installed"

# [5/5] Clone dotfiles repo and checkout files
echo "[5/5] Setting up dotfiles from repo..."

if [ ! -d "$HOME/.dotfiles" ]; then
    # Try SSH first, fallback to HTTPS
    git clone --bare https://github.com/karchtho/dotfiles.git "$HOME/.dotfiles" 2>/dev/null || \
    git clone --bare https://github.com/karchtho/dotfiles.git "$HOME/.dotfiles"

    # Backup existing files
    mkdir -p ~/.dotfiles-backup
    [ -f ~/.zshrc ] && mv ~/.zshrc ~/.dotfiles-backup/
    [ -f ~/.aliases ] && mv ~/.aliases ~/.dotfiles-backup/
    [ -f ~/.p10k.zsh ] && mv ~/.p10k.zsh ~/.dotfiles-backup/

    # Checkout files from repo
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>/dev/null || {
        # Handle conflicts if any
        git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
    }

    # Configure repo
    git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config --local status.showUntrackedFiles no
fi

# Set Zsh as default shell
echo "[✓] Setting Zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

echo "=============================================="
echo "✅ Setup complete!"
echo ""
echo "📋 Installed:"
echo "  • Zsh (as default shell)"
echo "  • Oh My Zsh"
echo "  • Powerlevel10k theme"
echo "  • zsh-autosuggestions plugin"
echo "  • zsh-syntax-highlighting plugin"
echo "  • Your dotfiles (.zshrc, .aliases, .p10k.zsh)"
echo ""
echo "⚠️  Next steps:"
echo "  1. Restart your terminal or run: exec zsh"
echo "  2. Your Powerlevel10k config is already loaded"
echo ""
