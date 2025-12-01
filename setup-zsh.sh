#!/bin/bash

echo "🚀 Setting up dotfiles + Zsh environment..."

# Install Zsh if needed
if ! command -v zsh &> /dev/null; then
    echo "📦 Installing Zsh..."
    sudo apt update
    sudo apt install -y zsh git curl
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install zsh plugins
echo "🔌 Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true

# Clone dotfiles
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "📥 Cloning dotfiles..."
    git clone --bare git@github.com:karchtho/dotfiles.git $HOME/.dotfiles
    
    # Create alias temporarily
    alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
    
    # Backup existing files
    mkdir -p ~/.dotfiles-backup
    
    # Checkout files
    echo "✅ Checking out dotfiles..."
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} ~/.dotfiles-backup/{}
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME checkout
    
    # Configure repo
    git --git-dir=$HOME/.dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Setting Zsh as default shell..."
    chsh -s $(which zsh)
fi

echo "✨ Setup complete!"
echo "Run 'exec zsh' to start using your new config"
