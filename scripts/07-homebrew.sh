#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing Homebrew (Linux) ==="

# BLOCK: Install Homebrew for Linux
# PURPOSE: Set up Homebrew package manager for Linux
# DETAILS: Installs Homebrew which provides access to many packages,
#          including neko (Haxe's runtime dependency).
#          Also sets HOMEBREW_FORBIDDEN_FORMULAE to prevent conflicts with system packages
#          (node, python, npm, etc.) that should be managed by other tools.
# IMPORTANCE: Required if you need packages from Homebrew that aren't in apt repos
#             (such as latest neko versions)

log "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to ~/.bashrc for future shells (idempotent)
touch ~/.bashrc
brew_shellenv='eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
if ! grep -Fxq "$brew_shellenv" ~/.bashrc; then
	echo "" >> ~/.bashrc
	echo "# Homebrew" >> ~/.bashrc
	echo "$brew_shellenv" >> ~/.bashrc
	brew_forbidden='export HOMEBREW_FORBIDDEN_FORMULAE="node python python3 pip npm pnpm yarn haxe claude"'
	echo "$brew_forbidden" >> ~/.bashrc
	echo "# Homebrew end" >> ~/.bashrc
	eval "$brew_forbidden"
fi

# Activate Homebrew in current shell
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

log "Verifying Homebrew installation..."
brew --version

log "✓ Homebrew installation complete"
