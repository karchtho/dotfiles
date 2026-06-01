# PowerShell Profile — cross-platform (Windows / macOS / Linux)

# ── Prompt (Oh-My-Posh) ──────────────────────────────────────────────────────
# Run: bin/bootstrap.ps1 (Windows) or bin/bootstrap.sh (macOS/Linux) to install
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $_omp_theme = if ($env:POSH_THEMES_PATH) {
        Join-Path $env:POSH_THEMES_PATH "powerlevel10k_rainbow.omp.json"
    } else {
        "powerlevel10k_rainbow"
    }
    oh-my-posh init pwsh --config $_omp_theme | Invoke-Expression
    Remove-Variable _omp_theme
}

# ── PSReadLine ───────────────────────────────────────────────────────────────
if (Get-Module -ListAvailable PSReadLine) {
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Key Tab            -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow        -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow      -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord 'Ctrl+r'     -Function ReverseSearchHistory
}

# ── Git aliases ──────────────────────────────────────────────────────────────
function gs    { git status @args }
function ga    { git add @args }
function gaa   { git add --all @args }
function gc    { git commit -m @args }
function gca   { git commit --amend @args }
function gp    { git push @args }
function gpf   { git push --force-with-lease @args }
function gl    { git pull @args }
function gf    { git fetch @args }
function gb    { git branch @args }
function gco   { git checkout @args }
function gcb   { git checkout -b @args }
function gsw   { git switch @args }
function gswc  { git switch -c @args }
function gm    { git merge @args }
function gr    { git rebase @args }
function glog  { git log --oneline --graph --decorate @args }
function gd    { git diff @args }
function gds   { git diff --staged @args }
function gst   { git stash push -u -m @args }
function gstp  { git stash pop @args }

# ── Navigation ───────────────────────────────────────────────────────────────
function ..    { Set-Location .. }
function ...   { Set-Location ../.. }
function ....  { Set-Location ../../.. }

# ── Utilities ────────────────────────────────────────────────────────────────
function reload { . $PROFILE }
function myip   { (Invoke-WebRequest -Uri 'https://ifconfig.me' -UseBasicParsing).Content.Trim() }
function ll     { Get-ChildItem -Force @args }
function cl     { Clear-Host }

# bat/batcat as cat replacement (same guard logic as .aliases.linux)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat @args }
} elseif (Get-Command batcat -ErrorAction SilentlyContinue) {
    function cat { batcat @args }
}

# ── Dotfiles (bare repo) ─────────────────────────────────────────────────────
function dotfiles { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" @args }

# ── Environment ──────────────────────────────────────────────────────────────
# Bun
if (Test-Path "$HOME/.bun/bin") {
    $env:BUN_INSTALL = "$HOME/.bun"
    $env:PATH = "$($env:BUN_INSTALL)/bin$([IO.Path]::PathSeparator)$($env:PATH)"
}

# NVM (nvm-windows or fnm)
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}
