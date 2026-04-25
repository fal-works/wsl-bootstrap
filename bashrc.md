# Understanding .bashrc

## Fundamentals

`~/.bashrc` is a shell configuration file that Bash executes automatically when starting an interactive non-login shell to set up environment variables, PATH, aliases, and tool initializations.

When running bash scripts (non-interactive shells), `.bashrc` is NOT executed by default, which is why the scripts in this repo explicitly source it with `source ~/.bashrc` before using tools or environment variables that were added to `.bashrc` by previous scripts.

## Example .bashrc After Running All Scripts

Below is what `.bashrc` looks like after running all scripts in this repository:

```bash
# ... [standard Ubuntu .bashrc content above] ...

# mise
eval "$(~/.local/bin/mise activate bash)"
# mise end

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
export HOMEBREW_FORBIDDEN_FORMULAE="node python python3 pip npm pnpm yarn haxe claude"
# Homebrew end

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

pnpm() {
  if [ "$1" = "self-update" ]; then
    echo "[.bashrc override] pnpm self-update is delegated to mise" >&2
    echo "$ mise upgrade npm:pnpm" >&2
    mise upgrade npm:pnpm || return
    echo "$ mise prune npm:pnpm" >&2
    mise prune npm:pnpm
  else
    command pnpm "$@"
  fi
}
# pnpm end

# neko
export NEKOPATH="/home/linuxbrew/.linuxbrew/lib/neko"
# neko end

# micro
export EDITOR="micro"
export VISUAL="micro"
# micro end
```
