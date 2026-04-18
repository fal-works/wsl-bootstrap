#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing Runtime Version Manager (mise) ==="

# BLOCK: Install runtime version manager (mise)
# PURPOSE: Set up version manager for multiple language runtimes
# DETAILS: Downloads and installs 'mise' (fork of asdf, faster version manager)
#          and activates it in ~/.bashrc shell configuration.
#          Verifies installation with 'mise doctor' check.
# IMPORTANCE: CRITICAL - Required to manage Node.js and Haxe versions

log "Installing mise version manager..."
curl https://mise.run | sh

# Activate mise in future shells (idempotent)
touch ~/.bashrc
mise_activation='eval "$(~/.local/bin/mise activate bash)"'
if ! grep -Fxq "$mise_activation" ~/.bashrc; then
   echo "" >> ~/.bashrc
   echo "# mise" >> ~/.bashrc
   echo "$mise_activation" >> ~/.bashrc
   echo "# mise end" >> ~/.bashrc
fi
# Activate mise in current shell
eval "$(~/.local/bin/mise activate bash)"

log "Verifying mise installation..."
mise doctor

log "Checking mise version..."
mise --version

log "✓ Runtime version manager installation complete"
