#!/bin/bash

echo "🚀 Installation de ZSH + Oh My Zsh + Powerlevel10k + Dotfiles"
echo "=================================================="

# [1/7] Install dependencies
echo "[1/7] Installation de zsh, curl, git..."
sudo apt update
sudo apt install -y zsh curl git

# [2/7] Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[2/7] Installation d'Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "[2/7] Oh My Zsh déjà installé, skip..."
fi

# [3/7] Install Powerlevel10k
echo "[3/7] Installation de Powerlevel10k..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "  Powerlevel10k déjà installé, skip..."
fi

# [4/7] Install zsh plugins
echo "[4/7] Installation des plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || echo "  zsh-autosuggestions déjà installé"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || echo "  zsh-syntax-highlighting déjà installé"

# [5/7] Clone dotfiles repo (bare)
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "[5/7] Clonage du repo dotfiles..."

    # Backup existing files
    mkdir -p ~/.dotfiles-backup
    [ -f ~/.zshrc ] && mv ~/.zshrc ~/.dotfiles-backup/
    [ -f ~/.aliases ] && mv ~/.aliases ~/.dotfiles-backup/
    [ -f ~/.p10k.zsh ] && mv ~/.p10k.zsh ~/.dotfiles-backup/

    # Clone bare repo (try SSH first, fallback to HTTPS)
    git clone --bare git@github.com:karchtho/dotfiles.git $HOME/.dotfiles 2>/dev/null || \
    git clone --bare https://github.com/karchtho/dotfiles.git $HOME/.dotfiles
    
    # Define alias temporarily
    function dotfiles {
        git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
    }
    
    # Checkout files (with conflict handling)
    if ! dotfiles checkout 2>&1; then
        echo "  Conflict detected, moving existing files to backup..."
        dotfiles checkout 2>&1 | grep -E "^\s+\." | sed 's/^\s*//' | while read -r file; do
            [ -f "$HOME/$file" ] && mv "$HOME/$file" ~/.dotfiles-backup/
        done
        dotfiles checkout
    fi
    
    # Configure repo
    dotfiles config --local status.showUntrackedFiles no
    
    echo "  ✅ Dotfiles clonés et installés"
else
    echo "[5/7] Dotfiles déjà installés, skip..."
fi

# [6/7] Create bin directory if needed
echo "[6/7] Configuration des répertoires..."
mkdir -p ~/bin

# [7/7] Set Zsh as default shell
echo "[7/7] Configuration de zsh comme shell par défaut..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

echo "=================================================="
echo "✅ Installation terminée !"
echo ""
echo "📋 Ce qui a été installé :"
echo "  • Zsh (shell par défaut)"
echo "  • Oh My Zsh"
echo "  • Powerlevel10k (thème)"
echo "  • zsh-autosuggestions"
echo "  • zsh-syntax-highlighting"
echo "  • Tes dotfiles personnalisés"
echo ""
echo "⚠  IMPORTANT :"
echo "  1. Redémarre ton terminal ou tape : exec zsh"
echo "  2. L'assistant Powerlevel10k va se lancer automatiquement"
echo "  3. Installe une Nerd Font pour les icônes :"
echo "     https://github.com/romkatv/powerlevel10k#fonts"
