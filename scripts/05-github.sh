#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Configuring GitHub Authentication ==="

# BLOCK: GitHub authentication setup
# PURPOSE: Set up secure GitHub credentials using gh CLI
# DETAILS: Performs the following:
#          1. Installs GitHub CLI (gh) for secure credential management
#          2. gh auth login: Securely stores GitHub credentials
#          3. gh auth status: Verifies successful authentication
# IMPORTANCE: CRITICAL - Required for secure GitHub access and GitHub CLI features.
#             Bonus: gh CLI provides powerful GitHub repo/PR/issue management.

log "Installing GitHub CLI (gh)..."
# Official installation method from https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

log "Authenticating with GitHub using gh CLI..."
log "Manual interaction required: You will be prompted to complete authentication."
log "See also: https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git"
gh auth login

log "Verifying GitHub authentication..."
gh auth status

log "✓ GitHub authentication complete"
