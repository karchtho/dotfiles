# dotfiles

Cross-platform shell setup for **zsh** (macOS / Linux / WSL) and **PowerShell** (Windows / macOS / Linux), managed with a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles).

## What's included

| File | Purpose |
|------|---------|
| `.zshrc` | Entry point — detects OS, sources platform file |
| `.zshrc.macos` | macOS zsh config (OMZ, nvm, ng completion) |
| `.zshrc.linux` | Linux/WSL zsh config (OMZ) |
| `.p10k.zsh.macos` / `.p10k.zsh.linux` | Powerlevel10k prompt config per platform |
| `.aliases` | Shared aliases (git, docker, navigation, tree…) |
| `.aliases.macos` / `.aliases.linux` | Platform-specific aliases |
| `Documents/PowerShell/Microsoft.PowerShell_profile.ps1` | PowerShell profile (Oh-My-Posh, git aliases, PSReadLine) |
| `bin/bootstrap.sh` | Install zsh, Oh-My-Zsh, Powerlevel10k, plugins, and font (macOS/Linux) |
| `bin/bootstrap.ps1` | Install Oh-My-Posh and font (Windows) |

## Install on a new machine

### 1 — Clone the bare repo

```sh
git clone --bare git@github.com:karchto/dotfiles.git "$HOME/.dotfiles"
```

### 2 — Check out the files

```sh
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
```

If git complains about existing files, back them up and retry:

```sh
mkdir -p ~/.dotfiles-backup
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout 2>&1 \
  | grep "^\s" | awk '{print $1}' \
  | xargs -I{} mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" checkout
```

### 3 — Hide untracked files

```sh
git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no
```

### 4 — Run bootstrap

**macOS / Linux:**
```sh
bash ~/bin/bootstrap.sh
```

Installs (skips anything already present):
- **Linux only:** zsh via `apt`, sets it as your default shell
- Oh-My-Zsh
- Powerlevel10k theme
- `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins
- MesloLGS NF font

On Linux, log out and back in after bootstrap so zsh takes effect. Then run `p10k configure` if you want to tweak the prompt.

**Windows (PowerShell, run elevated):**
```powershell
~\.dotfiles\bin\bootstrap.ps1
```

### 5 — Set terminal font

After bootstrap installs the font, configure each terminal to use **MesloLGS NF**:

#### macOS — Ghostty
Add to `~/.config/ghostty/config`:
```
font-family = MesloLGS NF
```

#### macOS — iTerm2
Preferences → Profiles → Text → Font → set to **MesloLGS NF**

#### macOS — Terminal.app
Terminal → Settings → Profiles → your profile → Font → Change → **MesloLGS NF**

#### Linux — Konsole
Settings → Edit Current Profile → Appearance → Font → **MesloLGS NF**

#### Windows — Windows Terminal
Settings → your profile → Appearance → Font face → **MesloLGS NF**

---

## Daily use

```sh
# Check status
dotfiles status

# Stage and commit changes
dotfiles add ~/.zshrc
dotfiles commit -m "update zshrc"
dotfiles push

# Pull updates on another machine
dotfiles pull
```

---

## How it works

`dotfiles` is an alias for `git --git-dir=$HOME/.dotfiles --work-tree=$HOME`.
The bare repo stores git data in `~/.dotfiles/` while treating your home directory as the working tree — no symlinks needed.

Platform detection happens in `.zshrc`:
- `$OSTYPE == darwin*` → sources `.zshrc.macos` and creates `~/.p10k.zsh → ~/.p10k.zsh.macos`
- `$OSTYPE == linux-gnu*` → sources `.zshrc.linux` and creates `~/.p10k.zsh → ~/.p10k.zsh.linux`

Tool guards: aliases and completions that depend on optional tools (`ng`, `bat`, `oh-my-posh`, `bun`) are wrapped in `command -v` checks so missing tools produce no errors on startup.
