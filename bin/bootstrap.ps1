# Bootstrap: installs Oh-My-Posh and MesloLGS NF font on Windows.
# Run once in an elevated PowerShell after cloning your dotfiles.

# ── Oh-My-Posh ───────────────────────────────────────────────────────────────
Write-Host "==> Oh-My-Posh"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "  Already installed."
} else {
    Write-Host "  Installing via winget..."
    winget install JanDeSmet.OhMyPosh --accept-package-agreements --accept-source-agreements
    # Reload PATH so oh-my-posh is available in this session
    $env:PATH = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine') + ';' +
                [System.Environment]::GetEnvironmentVariable('PATH', 'User')
}

# ── Font ─────────────────────────────────────────────────────────────────────
Write-Host "==> Font (MesloLGS NF)"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    Write-Host "  Installing via oh-my-posh font install..."
    oh-my-posh font install meslo
} else {
    Write-Host "  oh-my-posh not found — install it first, then re-run this script." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "Next steps:"
Write-Host "  1. Open Windows Terminal > Settings > your profile > Appearance"
Write-Host "  2. Set Font face to 'MesloLGS NF'"
Write-Host "  3. Restart Windows Terminal"
