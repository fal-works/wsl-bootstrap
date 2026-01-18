#!/bin/bash

# Exit immediately if any command exits with non-zero status
set -euo pipefail

# Load logger functions: log(), error()
source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"

log "=== Installing Python via uv ==="

# BLOCK: Install Python via uv
# PURPOSE: Provide a modern Python installer/manager without touching system Python
# DETAILS: Installs uv, then installs the latest Python
#          and makes versioned and default executables available via --default (experimental for now).

log "Installing uv (Python toolchain manager)..."
curl -LsSf https://astral.sh/uv/install.sh | sh

log "Installing latest Python with uv (default executables enabled)..."
uv python install --default

log "Verifying uv Python installation..."
uv python list

log "✓ Python installation via uv complete"
