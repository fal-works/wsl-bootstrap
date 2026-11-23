#!/bin/bash

# Exit on errors, unset variables, and pipeline failures
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing pnpm ==="

# Ensure mise is available
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
if ! command -v mise >/dev/null 2>&1; then
    error "mise not found. Run the script that installs mise first."
    exit 1
fi

# BLOCK: Install pnpm via mise (default aqua backend)
# PURPOSE: Set up pnpm package manager
# DETAILS: The default aqua backend installs pnpm's native binary from GitHub
#          releases. The npm backend is avoided because mise skips the script
#          that installs that binary, so pnpm would run through Node.js.
# IMPORTANCE: CRITICAL - pnpm is required for the stated dev environment.
log "Installing pnpm via mise (latest)..."
mise use -g pnpm@latest

# Re-activate mise so newly installed pnpm is on PATH
eval "$(mise activate bash)"

# BLOCK: Configure pnpm in ~/.bashrc (idempotent)
# PURPOSE: Set PNPM_HOME for `pnpm add -g` bins; override `pnpm self-update`
#          so it delegates to mise instead of overwriting the binary in place
#          (which would bypass mise's version management).
# DETAILS: The shell function only affects interactive shells.
# IMPORTANCE: CRITICAL
if ! grep -Fxq "# pnpm" ~/.bashrc; then
    cat >> ~/.bashrc <<'EOF'

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

pnpm() {
  if [ "$1" = "self-update" ]; then
    echo "[.bashrc override] pnpm self-update is delegated to mise" >&2
    echo "$ mise upgrade pnpm" >&2
    mise upgrade pnpm || return
    echo "$ mise prune pnpm" >&2
    mise prune pnpm
  else
    command pnpm "$@"
  fi
}
# pnpm end
EOF
fi

log "Verifying pnpm version..."
pnpm --version

log "✓ pnpm installation complete"
