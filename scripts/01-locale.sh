#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

# Load environment variables from .env file
source "$(dirname "${BASH_SOURCE[0]}")/../lib/load-env.sh" && load_env || exit 1

# Set defaults if not configured
UBUNTU_MIRROR="${UBUNTU_MIRROR:-}"
ADDITIONAL_LOCALES="${ADDITIONAL_LOCALES:-}"

log "=== Locale Configuration ==="

# BLOCK: Update APT package mirror (optional)
# PURPOSE: Speed up package downloads by using a geographically closer mirror
# DETAILS: If UBUNTU_MIRROR is set in .env, modifies the Ubuntu package source list
#          to use that mirror instead of archive.ubuntu.com.
#          Creates a backup (.bak) of the original sources file.
# IMPORTANCE: OPTIONAL - Not important unless you experience slow download speeds.
if [ -n "${UBUNTU_MIRROR}" ]; then
    log "Updating APT package mirror to: ${UBUNTU_MIRROR}"
    sudo sed -i.bak -r "s@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@${UBUNTU_MIRROR}@g" /etc/apt/sources.list.d/ubuntu.sources
else
    log "Skipping APT mirror update (UBUNTU_MIRROR not set)"
fi

# BLOCK: Configure additional locales (optional)
# PURPOSE: Generate locale data for additional languages beyond the default English
# DETAILS: If ADDITIONAL_LOCALES is set in .env, generates those locales.
#          This allows applications to use those locales if they request them.
#          For example, setting ADDITIONAL_LOCALES="ja_JP.UTF-8" enables Japanese
#          text rendering in applications, even though system messages stay in English.
# IMPORTANCE: OPTIONAL - Only needed if applications in your projects use non-English locales.
#             Leave empty to keep the system lean.
if [ -n "${ADDITIONAL_LOCALES}" ]; then
    log "Generating additional locales: ${ADDITIONAL_LOCALES}"
    for locale in ${ADDITIONAL_LOCALES}; do
        sudo locale-gen "${locale}"
    done
else
    log "Skipping additional locale generation (ADDITIONAL_LOCALES not set)"
fi

log "✓ Locale configuration complete"
