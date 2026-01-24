# WSL2 Development Environment Setup

Setup scripts for WSL2 (Ubuntu 24.04) environment tailored for JavaScript, Python, and Haxe development.

## Tools & Installation Methods

This setup installs:

- **System packages** (git-lfs, gh, etc.) - via apt
- **Node.js** - via mise (runtime version manager)
- **pnpm** - via npm (Node.js package manager)
- **Python** - via uv (Python installer/manager)
- **Haxe** - via mise (runtime version manager)
- **Neko VM** - via Homebrew (package manager)

## Usage

**Note:** These scripts must be run from inside WSL (Ubuntu), not from Windows command prompt or PowerShell.

**Prerequisites:** This setup assumes basic tools like `git`, `curl`, and `sudo` are already available in your WSL environment (they are included by default in Ubuntu 24.04).

1. Copy `.env.sample` to `.env` and configure (there are required variables to set)
2. Run scripts in order:
   ```bash
   bash scripts/01-locale.sh
   bash scripts/02-wsl.sh
   bash scripts/03-core-tools.sh
   bash scripts/04-git.sh
   bash scripts/05-github.sh
   bash scripts/06-mise.sh
   bash scripts/07-homebrew.sh
   bash scripts/08-javascript.sh
   bash scripts/09-python.sh
   bash scripts/10-haxe.sh
   ```
3. After completion, restart WSL: `wsl --shutdown` (from Windows command prompt or PowerShell)

## Scripts

- `01-locale.sh` - Locale and APT mirror
- `02-wsl.sh` - WSL2 system configuration
- `03-core-tools.sh` - Essential packages
- `04-git.sh` - Git configuration
- `05-github.sh` - GitHub CLI and authentication
- `06-mise.sh` - Runtime version manager
- `07-homebrew.sh` - Homebrew package manager
- `08-javascript.sh` - Node.js, pnpm (requires mise for Node.js)
- `09-python.sh` - Python via uv
- `10-haxe.sh` - Haxe, Neko, haxelib (requires mise and Homebrew)
