# WSL2 Development Environment Setup

Setup scripts for WSL2 (Ubuntu 24.04) environment tailored for JavaScript, Python, and Haxe development.

For a brief primer on `.bashrc` behavior in these scripts, see [bashrc.md](bashrc.md).

## Tools & Installation Methods

This setup installs:

- **System packages** (git-lfs, gh, etc.) - via apt
- **Node.js** - via mise (runtime version manager)
- **pnpm** - via curl and official installer
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
   bash scripts/08-nodejs.sh
   bash scripts/09-pnpm.sh
   bash scripts/10-python.sh
   bash scripts/11-haxe.sh
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
- `08-nodejs.sh` - Node.js (via mise)
- `09-pnpm.sh` - pnpm (official installer; requires Node.js first)
- `10-python.sh` - Python via uv
- `11-haxe.sh` - Haxe, Neko, haxelib (requires mise and Homebrew)
