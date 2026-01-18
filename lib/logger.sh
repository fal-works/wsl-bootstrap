#!/bin/bash

# Colored logging functions with wsl-bootstrap prefix
# Usage: source "$(dirname "${BASH_SOURCE[0]}")/../lib/logger.sh"
#        log "Your message here"
#        error "Error message here"

log() {
    printf "\033[1;36m[wsl-bootstrap]\033[0m %s\n" "$*"
}

error() {
    printf "\033[1;31m[wsl-bootstrap]\033[0m %s\n" "$*" >&2
}
