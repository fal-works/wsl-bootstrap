#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== WSL2 Configuration ==="

# BLOCK: Configure WSL2 system behavior
# PURPOSE: Optimize WSL environment for development by disabling Windows interop
# DETAILS: Creates /etc/wsl.conf with two settings:
#          - [interop] enabled=false: Disables running Windows programs (.exe) from WSL.
#            Prevents accidental use of Windows tools when Linux versions are intended.
#          - appendWindowsPath=false: Prevents Windows PATH from being added to WSL PATH.
#            Keeps Linux PATH clean and avoids conflicts with Windows programs.
#          Requires WSL restart to take effect.
# IMPORTANCE: RECOMMENDED - Keeps environments properly separated and prevents confusion.
#             Can be skipped if you intentionally want Windows<->Linux interop.
log "Configuring WSL2 system behavior..."

# Preserve existing wsl.conf while ensuring interop settings are present
if [ -f /etc/wsl.conf ]; then
	log "Backing up existing /etc/wsl.conf to /etc/wsl.conf.bak"
	sudo cp /etc/wsl.conf /etc/wsl.conf.bak
fi

# Create or update the interop section without clobbering other settings
tmp_file=$(mktemp)
if [ -f /etc/wsl.conf ]; then
	sudo cat /etc/wsl.conf > "$tmp_file"
fi

# Append interop block if not already present
if ! grep -q "^\[interop\]" "$tmp_file"; then
	cat <<'EOF' >> "$tmp_file"
[interop]
enabled=false
appendWindowsPath=false
EOF
else
    # Update existing interop block values in-place
	sed -i -E 's/^enabled=.*/enabled=false/' "$tmp_file"
	sed -i -E 's/^appendWindowsPath=.*/appendWindowsPath=false/' "$tmp_file"
fi

sudo mv "$tmp_file" /etc/wsl.conf
sudo chown root:root /etc/wsl.conf
sudo chmod 644 /etc/wsl.conf

# Verify wsl.conf was written correctly
log "Verifying wsl.conf configuration..."
if ! sudo grep -q "^\[interop\]" /etc/wsl.conf; then
    error "[interop] section not found in /etc/wsl.conf"
    exit 1
fi
if ! sudo grep -q "^enabled=false" /etc/wsl.conf; then
    error "interop enabled=false not found in /etc/wsl.conf"
    exit 1
fi
if ! sudo grep -q "^appendWindowsPath=false" /etc/wsl.conf; then
    error "appendWindowsPath=false not found in /etc/wsl.conf"
    exit 1
fi

log "✓ WSL2 configuration complete"
log "  Note: Run 'wsl --shutdown' from Windows PowerShell to apply changes"
