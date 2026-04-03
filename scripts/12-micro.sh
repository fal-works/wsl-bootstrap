#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing micro Editor ==="

# BLOCK: Install micro text editor
# PURPOSE: Set up micro as the default terminal text editor
# DETAILS: Performs the following:
#          1. Installs micro via apt
#          2. Verifies installation
log "Installing micro..."
sudo apt update
sudo apt install -y micro

log "Verifying micro installation..."
if ! command -v micro >/dev/null 2>&1; then
    error "micro not found after installation"
    exit 1
fi

# BLOCK: Set EDITOR and VISUAL environment variables
# PURPOSE: Configure micro as the default editor for shell tools (git, etc.)
# DETAILS: Appends EDITOR and VISUAL exports to ~/.bashrc (idempotent)

touch ~/.bashrc

# Determine which lines need to be added
editor_needed=false
visual_needed=false

if grep -q '^export EDITOR=' ~/.bashrc; then
    log "EDITOR already set in ~/.bashrc, skipping"
else
    editor_needed=true
fi

if grep -q '^export VISUAL=' ~/.bashrc; then
    log "VISUAL already set in ~/.bashrc, skipping"
else
    visual_needed=true
fi

# Append a single block for whichever variables are needed
if $editor_needed || $visual_needed; then
    echo "" >> ~/.bashrc
    echo "# micro" >> ~/.bashrc
    if $editor_needed; then
        echo 'export EDITOR="micro"' >> ~/.bashrc
        log "Added EDITOR=\"micro\" to ~/.bashrc"
    fi
    if $visual_needed; then
        echo 'export VISUAL="micro"' >> ~/.bashrc
        log "Added VISUAL=\"micro\" to ~/.bashrc"
    fi
    echo "# micro end" >> ~/.bashrc
fi

# Apply in current shell if not already set
if [ -z "${EDITOR:-}" ]; then
    export EDITOR="micro"
fi
if [ -z "${VISUAL:-}" ]; then
    export VISUAL="micro"
fi

log "✓ micro installation complete"
