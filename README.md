# Dotfiles
My shell configuration files, managed with a bare git repository.

## What's included
- `.zshrc` — Zsh config with Oh My Zsh, Powerlevel10k, plugins
- `.aliases` — Shell aliases (git, navigation, dev, system)
- `bin/rcc` — React component creator script

## Quick setup on a new machine

### One-command install (recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/karchtho/dotfiles/main/setup-zsh.sh | bash
```

This script will:
1. Install Zsh, Oh My Zsh, and Powerlevel10k
2. Clone your dotfiles repo (bare repository method)
3. Checkout your configuration files
4. Set everything up automatically

**Then restart your shell:**
```bash
exec zsh
```

Powerlevel10k configuration wizard will launch automatically.

---

## Manual installation (if you prefer step-by-step)

### 1. Install dependencies
```bash
# Install Zsh
sudo apt update && sudo apt install -y zsh git curl

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 2. Clone the dotfiles repo
```bash
git clone --bare git@github.com:karchtho/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

### 3. Checkout the files
```bash
dotfiles checkout
```

**If you get conflicts** (existing files that would be overwritten):
```bash
mkdir -p ~/.dotfiles-backup
mv ~/.zshrc ~/.dotfiles-backup/
# Move other conflicting files if needed
dotfiles checkout
```

### 4. Configure the repo
```bash
dotfiles config --local status.showUntrackedFiles no
```

### 5. Reload your shell
```bash
source ~/.zshrc
```

---

## How it works

This repo uses the **bare git repository** method. The git data lives in `~/.dotfiles` while files stay in their normal locations (`~/.zshrc`, `~/bin/`, etc.).

You interact with it using a `dotfiles` alias instead of `git`:
```bash
dotfiles status
dotfiles add ~/.zshrc
dotfiles commit -m "updated aliases"
dotfiles push
```

**Why isn't Oh My Zsh in the repo?**
- Keeps the repo lightweight (a few KB instead of 50+ MB)
- Oh My Zsh updates independently with `omz update`
- No merge conflicts between your config and Oh My Zsh updates
- Standard practice in the dotfiles community

---

## Daily usage

### Adding new files
```bash
dotfiles add ~/.some-config
dotfiles commit -m "added some-config"
dotfiles push
```

### Useful commands
| Command | Description |
|---------|-------------|
| `dotfiles status` | See what's changed |
| `dotfiles diff` | See actual changes |
| `dotfiles add -u` | Stage all modified tracked files |
| `dotfiles commit -m "msg"` | Commit changes |
| `dotfiles push` | Push to GitHub |
| `dotfiles pull` | Pull latest changes |

---

## Aliases cheatsheet

### Git
- `gs` → git status
- `ga` → git add
- `gc "msg"` → git commit -m "msg"
- `gp` → git push
- `gl` → git pull
- `glog` → pretty git log

### Navigation
- `..` / `...` / `....` → cd up directories
- `ll` → detailed file list

### Dev
- `nrd` → npm run dev
- `serve` → python http server on :8000
- `rcc component-name` → create React component

### System
- `update` → apt update && upgrade
- `reload` → source ~/.zshrc
