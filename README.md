# Dotfiles
My shell configuration files, managed with a bare git repository.

## What's included
- `.zshrc` — Zsh config with Oh My Zsh, Powerlevel10k, plugins (sources `.aliases`)
- `.aliases` — Shell aliases (git, navigation, dev, system, fail2ban)
- `.p10k.zsh` — Powerlevel10k theme configuration (auto-generated during setup)
- `bin/rcc` — React component creator script (create boilerplate React components)

## Quick setup on a new machine

### One-command install (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/karchtho/dotfiles/main/setup-shell.sh | bash
```

This script will:
1. Install Zsh, Oh My Zsh, Powerlevel10k, and plugins
2. Clone your dotfiles repo and checkout your configs
3. Set Zsh as your default shell

**Then restart your terminal or run:**
```bash
exec zsh
```

Your shell is ready to go!

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

**With SSH (requires SSH key configured):**
```bash
git clone --bare git@github.com:karchtho/dotfiles.git $HOME/.dotfiles
```

**Or with HTTPS:**
```bash
git clone --bare https://github.com/karchtho/dotfiles.git $HOME/.dotfiles
```

Then create the alias:
```bash
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

### 5. Configure Powerlevel10k (optional)

When you first load Zsh, Powerlevel10k will automatically launch its configuration wizard. Complete it to customize your prompt appearance.

This creates `~/.p10k.zsh` which you should add to your dotfiles:
```bash
dotfiles add ~/.p10k.zsh
dotfiles commit -m "add p10k configuration"
dotfiles push
```

### 6. Reload your shell
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
