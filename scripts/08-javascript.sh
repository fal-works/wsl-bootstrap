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

# BLOCK: Install Node.js and pnpm via version manager
# PURPOSE: Set up Node.js runtime and pnpm package manager
# DETAILS: Performs the following:
#          1. Installs specified version of Node.js globally
#          2. Installs pnpm package manager)
#          3. Sets both as global defaults via 'mise use -g'
#          Node.js is used for JavaScript development, pnpm is a faster npm alternative
# IMPORTANCE: CRITICAL - Node.js and pnpm are required for stated dev environment.
log "Installing Node.js ${NODE_VERSION}..."
mise install node@${NODE_VERSION}
mise use -g node@${NODE_VERSION}

log "Installing pnpm package manager..."
mise install pnpm
mise use -g pnpm

# Re-activate mise to update PATH with newly installed tools
eval "$(mise activate bash)"

log "Verifying Node.js and pnpm versions..."
node --version
pnpm --version

log "✓ JavaScript tools installation complete"
log "  Installed: Node.js ${NODE_VERSION}, pnpm"
