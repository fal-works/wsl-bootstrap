#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing Core Tools ==="

# BLOCK: Install core system packages
# PURPOSE: Add essential tools for development
# DETAILS: Updates package list then installs:
#          - git-lfs: Handles large files in Git repositories (images, binaries, etc.)
#          - ripgrep: Fast regex-based code search tool (better than grep, needed by AI agents)
#          - build-essential: Compiler toolchain (gcc, g++, make) for building native modules
#          - libssl-dev: OpenSSL development headers (required for crypto and SSL operations)
# IMPORTANCE: RECOMMENDED - These tools are widely used in development workflows.
log "Updating package lists..."
sudo apt update

log "Installing core packages (git-lfs, ripgrep, build-essential, libssl-dev)..."
sudo apt install -y git-lfs ripgrep build-essential libssl-dev

# Verify installations
log "Verifying core packages installation..."
if ! command -v git-lfs >/dev/null 2>&1; then
    error "git-lfs not found after installation"
    exit 1
fi
if ! command -v rg >/dev/null 2>&1; then
    error "ripgrep (rg) not found after installation"
    exit 1
fi
if ! command -v gcc >/dev/null 2>&1; then
    error "build-essential (gcc) not found after installation"
    exit 1
fi

log "✓ Core tools installation complete"
