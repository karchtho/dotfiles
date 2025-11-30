#!/bin/bash

# =============================================================================
# Setup ZSH complet : Oh My Zsh + Powerlevel10k + Plugins
# Usage: chmod +x setup-zsh.sh && ./setup-zsh.sh
# =============================================================================

set -e

echo "🚀 Installation de ZSH + Oh My Zsh + Powerlevel10k"
echo "=================================================="

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Installation des paquets
echo -e "${BLUE}[1/6]${NC} Installation de zsh, curl, git..."
sudo apt update
sudo apt install -y zsh curl git

# 2. Installation Oh My Zsh (non-interactive)
echo -e "${BLUE}[2/6]${NC} Installation d'Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "   Oh My Zsh déjà installé, skip..."
fi

# 3. Installation Powerlevel10k
echo -e "${BLUE}[3/6]${NC} Installation de Powerlevel10k..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 4. Installation des plugins
echo -e "${BLUE}[4/6]${NC} Installation des plugins..."

# Auto-suggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# Syntax highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# 5. Configuration .zshrc
echo -e "${BLUE}[5/6]${NC} Configuration de .zshrc..."

# Backup
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi

# Set theme
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Set plugins
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting sudo history)/' ~/.zshrc

# 6. Changer le shell par défaut
echo -e "${BLUE}[6/6]${NC} Configuration de zsh comme shell par défaut..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
fi

echo ""
echo "=================================================="
echo -e "${GREEN}✅ Installation terminée !${NC}"
echo ""
echo "📋 Ce qui a été installé :"
echo "   • Zsh (shell par défaut)"
echo "   • Oh My Zsh"
echo "   • Powerlevel10k (thème)"
echo "   • zsh-autosuggestions"
echo "   • zsh-syntax-highlighting"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANT :${NC}"
echo "   1. Redémarre ton terminal ou tape : exec zsh"
echo "   2. L'assistant Powerlevel10k va se lancer automatiquement"
echo "   3. Installe une Nerd Font pour les icônes :"
echo "      https://github.com/romkatv/powerlevel10k#fonts"
echo ""
