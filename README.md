# Dotfiles

My shell configuration files, managed with a bare git repository.

## What's included

- `.zshrc` — Zsh config with Oh My Zsh, Powerlevel10k, plugins
- `.aliases` — Shell aliases (git, navigation, dev, system)
- `bin/rcc` — React component creator script
- `setup-zsh.sh` — Fresh install script for Zsh + Oh My Zsh + Powerlevel10k

## How it works

This repo uses the **bare git repository** method. Instead of keeping dotfiles in a folder with symlinks, the git data lives in `~/.dotfiles` while the actual files stay in their normal locations (`~/.zshrc`, `~/bin/`, etc.).

You interact with it using a `dotfiles` alias instead of `git`:

```bash
dotfiles status
dotfiles add ~/.zshrc
dotfiles commit -m "updated aliases"
dotfiles push
```

## Installation on a new machine

### 1. Clone the bare repository

```bash
git clone --bare git@github.com:karchtho/dotfiles.git $HOME/.dotfiles
```

### 2. Set up the alias (temporary, until .zshrc is loaded)

```bash
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

### 3. Checkout the files

```bash
dotfiles checkout
```

**What does `checkout` do?** It takes the files stored in your git repo and copies them to your home directory. So `.zshrc` from the repo becomes `~/.zshrc`, `bin/rcc` becomes `~/bin/rcc`, etc.

**If you get errors** about existing files that would be overwritten:

```bash
# Create a backup folder
mkdir -p ~/.dotfiles-backup

# Move conflicting files (adjust as needed)
mv ~/.zshrc ~/.dotfiles-backup/
mv ~/bin/rcc ~/.dotfiles-backup/

# Try again
dotfiles checkout
```

### 4. Configure git to hide untracked files

```bash
dotfiles config --local status.showUntrackedFiles no
```

Without this, `dotfiles status` would list every file in your home directory.

### 5. Load your config

```bash
source ~/.zshrc
```

## First-time setup (fresh Ubuntu)

If Zsh and Oh My Zsh aren't installed yet:

```bash
# Run the setup script
chmod +x ~/setup-zsh.sh
./setup-zsh.sh

# Restart your shell
exec zsh
```

Powerlevel10k's configuration wizard will launch automatically.

## Adding new files

```bash
dotfiles add ~/.some-config
dotfiles commit -m "added some-config"
dotfiles push
```

## Useful commands

| Command | Description |
|---------|-------------|
| `dotfiles status` | See what's changed |
| `dotfiles diff` | See actual changes |
| `dotfiles add -u` | Stage all modified tracked files |
| `dotfiles commit -m "msg"` | Commit changes |
| `dotfiles push` | Push to GitHub |
| `dotfiles pull` | Pull latest changes |

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
