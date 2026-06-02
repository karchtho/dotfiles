#!/usr/bin/env bash
# Bootstrap: installs zsh, Oh-My-Zsh, Powerlevel10k, plugins, and MesloLGS NF font.
# Run once after checking out your dotfiles on a new machine.
set -euo pipefail

OS="$(uname)"

# ── zsh (Linux only — macOS ships with zsh) ──────────────────────────────────
if [[ "$OS" == "Linux" ]]; then
    if ! command -v zsh &>/dev/null; then
        echo "==> Installing zsh..."
        sudo apt-get update -qq && sudo apt-get install -y zsh curl git
    else
        echo "==> zsh already installed ($(zsh --version | head -1))"
    fi

    current_shell="$(getent passwd "$USER" | cut -d: -f7)"
    if [[ "$current_shell" != "$(command -v zsh)" ]]; then
        echo "==> Setting zsh as default shell..."
        chsh -s "$(command -v zsh)"
    fi
fi

# ── Oh-My-Zsh ────────────────────────────────────────────────────────────────
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "==> Oh-My-Zsh already installed."
else
    echo "==> Installing Oh-My-Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ── Powerlevel10k ─────────────────────────────────────────────────────────────
if [[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    echo "==> Powerlevel10k already installed."
else
    echo "==> Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k \
        "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# ── Plugins ──────────────────────────────────────────────────────────────────
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
        echo "==> $plugin already installed."
    else
        echo "==> Installing $plugin..."
        git clone --depth=1 "https://github.com/zsh-users/$plugin" \
            "$ZSH_CUSTOM/plugins/$plugin"
    fi
done

# ── Font ─────────────────────────────────────────────────────────────────────
install_font_macos() {
    if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
        echo "==> MesloLGS NF already installed."
        return
    fi
    echo "==> Installing MesloLGS NF via Homebrew..."
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-meslo-lg-nerd-font
}

install_font_linux() {
    local font_dir="$HOME/.local/share/fonts/MesloLGS"
    if [[ -d "$font_dir" && -n "$(ls "$font_dir" 2>/dev/null)" ]]; then
        echo "==> MesloLGS NF already installed."
        return
    fi
    echo "==> Installing MesloLGS NF font..."
    mkdir -p "$font_dir"
    local base="https://github.com/romkatv/powerlevel10k-media/raw/master"
    local files=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
    for f in "${files[@]}"; do
        curl -fsSL "${base}/${f// /%20}" -o "${font_dir}/${f}"
    done
    fc-cache -f "$font_dir"
    echo "  Font installed."
}

case "$OS" in
    Darwin)
        install_font_macos
        ;;
    Linux)
        install_font_linux
        ;;
    *)
        echo "Unknown OS — see README for manual steps." >&2
        exit 1
        ;;
esac

echo ""
echo "Done."
if [[ "$OS" == "Linux" ]]; then
    echo "Next steps:"
    echo "  1. Log out and back in (or open a new terminal) for zsh to take effect"
    echo "  2. Set your terminal font to 'MesloLGS NF'"
    echo "  3. Run 'p10k configure' to customize the prompt"
else
    echo "Set your terminal font to 'MesloLGS NF' (see README)."
fi
