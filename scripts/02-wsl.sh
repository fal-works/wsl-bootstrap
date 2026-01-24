#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== WSL2 Configuration ==="

# BLOCK: Configure WSL2 system behavior
# PURPOSE: Optimize WSL environment for development by disabling Windows interop
# DETAILS: Creates /etc/wsl.conf with two settings if no [interop] section exists already:
#          - [interop] enabled=false: Disables running Windows programs (.exe) from WSL.
#            Prevents accidental use of Windows tools when Linux versions are intended.
#          - appendWindowsPath=false: Prevents Windows PATH from being added to WSL PATH.
#            Keeps Linux PATH clean and avoids conflicts with Windows programs.
#          If an [interop] section already exists, the script skips changes and prints a note.
#          Requires WSL restart to take effect.
# IMPORTANCE: RECOMMENDED - Keeps environments properly separated and prevents confusion.
#             Can be skipped if you intentionally want Windows<->Linux interop.
log "Configuring WSL2 system behavior..."

# If an interop section already exists, leave it untouched
if [ -f /etc/wsl.conf ] && sudo grep -q "^\[interop\]" /etc/wsl.conf; then
	log "Existing [interop] section found in /etc/wsl.conf; skipping changes."
	log "  Note: Update it manually if you want enabled=false and appendWindowsPath=false."
	exit 0
fi

# Preserve existing wsl.conf before we append our block
if [ -f /etc/wsl.conf ]; then
	log "Backing up existing /etc/wsl.conf to /etc/wsl.conf.bak"
	sudo cp /etc/wsl.conf /etc/wsl.conf.bak
fi

# Append interop section (or create the file) without touching other settings
tmp_file=$(mktemp)
[ -f /etc/wsl.conf ] && sudo cat /etc/wsl.conf > "$tmp_file"
cat <<'EOF' >> "$tmp_file"

[interop]
enabled=false
appendWindowsPath=false
EOF

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
