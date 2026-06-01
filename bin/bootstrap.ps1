# Bootstrap for Windows: installs Oh-My-Posh, MesloLGS NF font, and writes
# the PowerShell profile to the correct Windows location.
# Run once in an elevated PowerShell after cloning your dotfiles.

# ── Oh-My-Posh ───────────────────────────────────────────────────────────────
Write-Host "==> Oh-My-Posh"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "  Already installed."
} else {
    Write-Host "  Installing via winget..."
    winget install JanDeSmet.OhMyPosh --accept-package-agreements --accept-source-agreements
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('PATH', 'User')
}

# ── Font ─────────────────────────────────────────────────────────────────────
Write-Host "==> Font (MesloLGS NF)"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh font install meslo
} else {
    Write-Host "  oh-my-posh not found — re-run after install." -ForegroundColor Yellow
}

# ── PowerShell profile ───────────────────────────────────────────────────────
Write-Host "==> PowerShell profile"
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

@'
# PowerShell Profile — Windows

# ── Prompt (Oh-My-Posh) ──────────────────────────────────────────────────────
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
    Set-PSReadLineKeyHandler -Key Tab        -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow    -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow  -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -Function ReverseSearchHistory
}

# ── Git aliases ──────────────────────────────────────────────────────────────
function gs   { git status @args }
function ga   { git add @args }
function gaa  { git add --all @args }
function gc   { git commit -m @args }
function gca  { git commit --amend @args }
function gp   { git push @args }
function gpf  { git push --force-with-lease @args }
function gl   { git pull @args }
function gf   { git fetch @args }
function gb   { git branch @args }
function gco  { git checkout @args }
function gcb  { git checkout -b @args }
function gsw  { git switch @args }
function gswc { git switch -c @args }
function gm   { git merge @args }
function gr   { git rebase @args }
function glog { git log --oneline --graph --decorate @args }
function gd   { git diff @args }
function gds  { git diff --staged @args }
function gst  { git stash push -u -m @args }
function gstp { git stash pop @args }

# ── Navigation ───────────────────────────────────────────────────────────────
function ..   { Set-Location .. }
function ...  { Set-Location ../.. }
function .... { Set-Location ../../.. }

# ── Utilities ────────────────────────────────────────────────────────────────
function reload { . $PROFILE }
function myip   { (Invoke-WebRequest -Uri 'https://ifconfig.me' -UseBasicParsing).Content.Trim() }
function ll     { Get-ChildItem -Force @args }
function cl     { Clear-Host }

if (Get-Command bat -ErrorAction SilentlyContinue) {
    function cat { bat @args }
}

# ── Dotfiles (bare repo) ─────────────────────────────────────────────────────
function dotfiles { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" @args }

# ── Environment ──────────────────────────────────────────────────────────────
if (Test-Path "$HOME/.bun/bin") {
    $env:BUN_INSTALL = "$HOME/.bun"
    $env:PATH = "$($env:BUN_INSTALL)/bin;$($env:PATH)"
}

if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd | Out-String | Invoke-Expression
}
'@ | Set-Content -Path $PROFILE -Encoding UTF8

Write-Host "  Profile written to $PROFILE"

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "Next steps:"
Write-Host "  1. Open Windows Terminal > Settings > your profile > Appearance"
Write-Host "  2. Set Font face to 'MesloLGS NF'"
Write-Host "  3. Restart Windows Terminal"
