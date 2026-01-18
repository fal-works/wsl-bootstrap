# Agent Context: WSL Bootstrap Scripts

## Repository Overview

See `README.md` for repository purpose, tools installed, usage instructions, and script list.

## Core Scripting Patterns

- **Error handling:** All scripts use `set -euo pipefail` - commands fail immediately on error.
- **Loading .env variables:** Use relative path from script location to find `.env` at repo root, with error handling.
- **Idempotent .bashrc modifications:** Check with `grep -Fxq` before appending to avoid duplicates.
- **Tool availability checks (for tools from previous scripts):** Source `.bashrc` first to load PATH updates, then verify with `command -v`.
- **Inline Documentation:** Each script block has comments explaining purpose and key steps.

## Shared Functions

Functions in `lib/` are sourced by `scripts/` for reusable logging and environment setup.

## Dependencies

Scripts run in order (01→10) since there are inter-script dependencies, e.g., scripts using `mise` require the `mise` installation script to be run first.
