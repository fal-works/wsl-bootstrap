#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing Core Tools ==="

log "Updating package lists..."
sudo apt update

# BLOCK: Git tooling
# PURPOSE: Git extension for large file support
# DETAILS:
#          - git-lfs: Handles large files in Git repositories (images, binaries, etc.)
# IMPORTANCE: RECOMMENDED
log "Installing Git tooling (git-lfs)..."
sudo apt install -y \
    git-lfs

# BLOCK: Search & file navigation tools
# PURPOSE: Fast, modern alternatives to grep/find for code search and directory browsing
# DETAILS:
#          - ripgrep:  Fast regex-based code search tool (better than grep, needed by AI agents)
#          - fd-find:  Fast and user-friendly alternative to find (command: fdfind)
#          - tree:     Displays directory structure as a tree
# IMPORTANCE: RECOMMENDED
log "Installing search & navigation tools (ripgrep, fd-find, tree)..."
sudo apt install -y \
    ripgrep \
    fd-find \
    tree

# BLOCK: Build tools
# PURPOSE: Compiler toolchain and crypto headers for building native modules
# DETAILS:
#          - build-essential: Compiler toolchain (gcc, g++, make) for building native modules
#          - libssl-dev:      OpenSSL development headers (required for crypto and SSL operations)
# IMPORTANCE: RECOMMENDED
log "Installing build tools (build-essential, libssl-dev)..."
sudo apt install -y \
    build-essential \
    libssl-dev

# BLOCK: Dev utilities
# PURPOSE: General-purpose utilities for scripting and development
# DETAILS:
#          - jq:         Command-line JSON processor (parsing/filtering JSON in shell scripts)
#          - shellcheck: Static analysis tool for shell scripts (linting)
# IMPORTANCE: RECOMMENDED
log "Installing dev utilities (jq, shellcheck)..."
sudo apt install -y \
    jq \
    shellcheck

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
if ! command -v fdfind >/dev/null 2>&1; then
    error "fd-find (fdfind) not found after installation"
    exit 1
fi
if ! command -v tree >/dev/null 2>&1; then
    error "tree not found after installation"
    exit 1
fi
if ! command -v gcc >/dev/null 2>&1; then
    error "build-essential (gcc) not found after installation"
    exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
    error "jq not found after installation"
    exit 1
fi
if ! command -v shellcheck >/dev/null 2>&1; then
    error "shellcheck not found after installation"
    exit 1
fi

log "✓ Core tools installation complete"
