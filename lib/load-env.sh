#!/bin/bash

# Load environment variables from .env file in repo root
# Usage: source "$(dirname "${BASH_SOURCE[0]}")/../lib/load-env.sh" && load_env || exit 1
load_env() {
    local repo_root
    repo_root="$(cd "$(dirname "${BASH_SOURCE[1]}")/.." && pwd)"
    local env_file="${repo_root}/.env"
    
    if [[ ! -f "$env_file" ]]; then
        echo "Error: .env file not found at $env_file" >&2
        return 1
    fi
    
    source "$env_file" || {
        echo "Error: Failed to source .env file at $env_file" >&2
        return 1
    }
}
