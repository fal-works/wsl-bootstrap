#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

# Load environment variables from .env file
source "$(dirname "${BASH_SOURCE[0]}")/../lib/load-env.sh" && load_env || exit 1

# Validate required environment variables
if [ -z "${HAXE_VERSION}" ]; then
    error "HAXE_VERSION is not set in the .env file"
    exit 1
fi

log "=== Installing Haxe and Related Tools ==="

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

# Ensure Homebrew is available before proceeding
if ! command -v brew >/dev/null 2>&1; then
    error "brew not found. Run the script that installs Homebrew first."
    exit 1
fi

# BLOCK: Install Haxe compiler
# PURPOSE: Set up Haxe compiler
# DETAILS: Performs the following:
#          1. Installs specified Haxe version via mise
#          2. Sets Haxe as global default
#          3. Verifies installation

log "Installing Haxe ${HAXE_VERSION}..."
mise install haxe@${HAXE_VERSION}
mise use -g haxe@${HAXE_VERSION}

# Re-activate mise to update PATH with newly installed tools
eval "$(mise activate bash)"

log "Verifying Haxe version..."
haxe --version

# BLOCK: Install Neko VM
# PURPOSE: Set up Neko VM (Haxe's runtime dependency)
# DETAILS: Performs the following:
#          1. Installs Neko VM via Homebrew
#          2. Sets NEKOPATH environment variable for future shells
#          3. Sets NEKOPATH in current shell
#          4. Verifies installation

log "Installing Neko VM (via Homebrew). It may take a while..."
brew install neko

# Add NEKOPATH to ~/.bashrc for future shells (idempotent)
touch ~/.bashrc
neko_path='export NEKOPATH="/home/linuxbrew/.linuxbrew/lib/neko"'
if ! grep -Fxq "$neko_path" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# neko" >> ~/.bashrc
    echo "$neko_path" >> ~/.bashrc
    echo "# neko end" >> ~/.bashrc
fi
# Set NEKOPATH in current shell
export NEKOPATH="/home/linuxbrew/.linuxbrew/lib/neko"

log "Verifying Neko version..."
neko -version

# BLOCK: Initialize Haxe library manager (haxelib)
# PURPOSE: Configure haxelib to store packages in user home directory
# DETAILS: Performs the following:
#          1. Creates ~/haxelib directory for Haxe libraries
#          2. Configures haxelib to use this directory
#          3. Updates haxelib itself to latest version
#          This allows per-user library management and avoids permission issues.
# IMPORTANCE: CRITICAL - haxelib is essential for managing Haxe libraries.

log "Configuring haxelib..."
if ! command -v haxelib >/dev/null 2>&1; then
    error "Command haxelib not found. Ensure Haxe is installed correctly."
    exit 1
fi
mkdir -p ~/haxelib
haxelib setup ~/haxelib
haxelib --global update haxelib

log "Verifying haxelib setup..."
haxelib config

log "✓ Haxe installation complete"
log "  Installed: Haxe ${HAXE_VERSION}, Neko $(neko -version)"
