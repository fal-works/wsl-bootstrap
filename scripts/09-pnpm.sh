#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing pnpm ==="

# Ensure Node.js is available
# Don't error if ~/.bashrc is missing, as Node.js might be installed without mise
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
if ! command -v node >/dev/null 2>&1; then
    error "Node.js not found. Run the script that installs Node.js first."
    exit 1
fi

# BLOCK: Install pnpm (standalone)
# PURPOSE: Set up pnpm package manager using official installer
# DETAILS: Installs pnpm globally as a standalone package manager (not version-managed)
#          pnpm can self-update independently of Node.js via: pnpm self-update
# IMPORTANCE: CRITICAL - pnpm is required for the stated dev environment.
if command -v pnpm >/dev/null 2>&1; then
    log "pnpm already installed. Skipping installer."
else
    log "Installing pnpm package manager (official installer)..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# Re-source ~/.bashrc to update PATH with newly installed pnpm
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

log "Verifying pnpm version..."
pnpm --version

log "✓ pnpm installation complete"
