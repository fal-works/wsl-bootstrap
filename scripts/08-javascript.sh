#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

# Load environment variables from .env file
source "$(dirname "${BASH_SOURCE[0]}")/../lib/load-env.sh" && load_env || exit 1

# Validate required environment variables
if [ -z "${NODE_VERSION}" ]; then
    error "NODE_VERSION is not set in the .env file"
    exit 1
fi

log "=== Installing JavaScript Tools ==="

# Ensure mise is available before proceeding
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
else
    error "~/.bashrc not found. Run the script that installs mise first."
    exit 1
fi
if ! command -v mise >/dev/null 2>&1; then
    error "mise not found. Run the script that installs mise first."
    exit 1
fi

# BLOCK: Install Node.js
# PURPOSE: Set up Node.js runtime
# DETAILS: Installs specified version of Node.js globally and sets as default
#          Node.js is used for JavaScript development and is managed via mise
# IMPORTANCE: CRITICAL - Node.js is required for stated dev environment.
log "Installing Node.js ${NODE_VERSION}..."
mise install node@${NODE_VERSION}
mise use -g node@${NODE_VERSION}

# Re-activate mise to update PATH with newly installed tools
eval "$(mise activate bash)"

# BLOCK: Install pnpm
# PURPOSE: Set up pnpm package manager
# DETAILS: Installs pnpm globally using official installer as a standalone package manager
#          pnpm is not version-managed and can self-update independently of Node.js
#          Updates via: pnpm self-update
# IMPORTANCE: CRITICAL - pnpm is required for stated dev environment.
log "Installing pnpm package manager..."
curl -fsSL https://get.pnpm.io/install.sh | sh -

log "Verifying Node.js and pnpm versions..."
node --version
pnpm --version

log "✓ JavaScript tools installation complete"
log "  Installed: Node.js ${NODE_VERSION}, pnpm"
