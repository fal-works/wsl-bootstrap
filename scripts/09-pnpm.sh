#!/bin/bash

# Exit immediately if any command exits with non-zero status
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

# BLOCK: Install pnpm via mise (npm backend)
# PURPOSE: Set up pnpm package manager
# DETAILS: Uses the npm backend (not the default standalone).
#          The standalone bundles its own Node runtime, which can trigger
#          false-positive warnings on the Node version in some sandboxed environemnts.
#          The npm backend installs pure-JS pnpm that runs on the active mise Node.
# IMPORTANCE: CRITICAL - pnpm is required for the stated dev environment.
log "Installing pnpm via mise (npm backend, latest)..."
mise use -g npm:pnpm@latest

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
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

pnpm() {
  if [ "$1" = "self-update" ]; then
    echo "[.bashrc override] pnpm self-update is delegated to mise" >&2
    echo "$ mise upgrade npm:pnpm" >&2
    mise upgrade npm:pnpm || return
    echo "$ mise prune npm:pnpm" >&2
    mise prune npm:pnpm
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
