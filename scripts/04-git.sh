#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

# Load environment variables from .env file
source "$(dirname "${BASH_SOURCE[0]}")/../lib/load-env.sh" && load_env || exit 1

# Validate required environment variables
for var in GIT_USER_NAME GIT_USER_EMAIL; do
    if [ -z "${!var}" ]; then
        error "$var is not set in the .env file"
        exit 1
    fi
done

log "=== Configuring Git ==="

# BLOCK: Configure Git user identity and options
# PURPOSE: Set up Git user identity and options for best practices
# DETAILS: Performs the following:
#          1. git lfs install: Registers git-lfs hooks for large file tracking
#          2. git config: Sets global author name/email for commits
#          3. core.autocrlf=input: Convert CRLF->LF on commit (good for cross-platform)
#          4. core.sparseCheckout=true: Enable partial clones (useful for large repos)
#          5. init.defaultBranch=main: Use 'main' instead of 'master' for new repos
#          6. pull.rebase=true: Rebase on pull for cleaner linear history
#          7. fetch.prune=true: Auto-remove stale remote references on fetch
# IMPORTANCE: CRITICAL - Git config is needed for commits.

log "Installing git-lfs..."
git lfs install

log "Configuring Git user identity..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

log "Configuring Git options..."
git config --global core.autocrlf input
git config --global core.sparseCheckout true
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global fetch.prune true

# Verify Git configuration
log "Verifying Git configuration..."
if [ "$(git config --global user.name)" != "$GIT_USER_NAME" ]; then
    error "Git user.name not set correctly"
    exit 1
fi
if [ "$(git config --global user.email)" != "$GIT_USER_EMAIL" ]; then
    error "Git user.email not set correctly"
    exit 1
fi
if [ "$(git config --global core.autocrlf)" != "input" ]; then
    error "Git core.autocrlf not set correctly"
    exit 1
fi

log "✓ Git configuration complete"
log "  User: $GIT_USER_NAME <$GIT_USER_EMAIL>"
