#!/usr/bin/env bash
# Bootstrap: installs MesloLGS NF font and Oh-My-Posh on macOS and Linux.
# Run once after cloning your dotfiles on a new machine.
set -euo pipefail

# ── Font ─────────────────────────────────────────────────────────────────────
install_font_macos() {
    if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
        echo "  MesloLGS NF already installed."
        return
    fi
    echo "  Installing MesloLGS NF via Homebrew..."
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew install --cask font-meslo-lg-nerd-font
}

install_font_linux() {
    local font_dir="$HOME/.local/share/fonts/MesloLGS"
    if [[ -d "$font_dir" && -n "$(ls "$font_dir" 2>/dev/null)" ]]; then
        echo "  MesloLGS NF already installed."
        return
    fi
    echo "  Installing MesloLGS NF font..."
    mkdir -p "$font_dir"
    local base="https://github.com/romkatv/powerlevel10k-media/raw/master"
    local files=("MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf")
    for f in "${files[@]}"; do
        curl -fsSL "${base}/${f// /%20}" -o "${font_dir}/${f}"
    done
    fc-cache -f "$font_dir"
    echo "  Font installed."
}

# ── Oh-My-Posh ───────────────────────────────────────────────────────────────
install_omp_macos() {
    if command -v oh-my-posh &>/dev/null; then
        echo "  oh-my-posh already installed."
        return
    fi
    echo "  Installing oh-my-posh..."
    brew install jandedobbeleer/oh-my-posh/oh-my-posh
}

install_omp_linux() {
    if command -v oh-my-posh &>/dev/null; then
        echo "  oh-my-posh already installed."
        return
    fi
    echo "  Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
}

# ── Main ─────────────────────────────────────────────────────────────────────
case "$(uname)" in
    Darwin)
        echo "==> macOS detected"
        echo "--> Font"
        install_font_macos
        echo "--> Oh-My-Posh"
        install_omp_macos
        ;;
    Linux)
        echo "==> Linux detected"
        echo "--> Font"
        install_font_linux
        echo "--> Oh-My-Posh"
        install_omp_linux
        ;;
    *)
        echo "Unknown OS — see README for manual steps." >&2
        exit 1
        ;;
esac

echo ""
echo "Done. Next: set your terminal font to 'MesloLGS NF' (see README)."
