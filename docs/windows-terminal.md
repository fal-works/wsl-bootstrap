# Windows Terminal Settings

## Overriding the Enter Key

With some IMEs, Enter both confirms composition *and* submits input — a combination that can cause accidental command executions. This is particularly disruptive in coding agent CLIs (Claude Code, Codex).

The example below remaps Enter to `LF` (`\n`) for a specific WSL profile and moves `CR` to `Ctrl+Enter`.
This affects only what Windows Terminal sends; `.inputrc` is untouched, so standard shell readline behavior is preserved.
Because this overrides standard behavior, it is entirely optional.

The snippet below shows only the relevant entries for this override.
Merge the entries into your existing settings JSON.
The `User.sendInput` IDs (e.g. `LF_U000A`) are arbitrary — use any unique string you like.

```json
{
    "actions": [
        {
            "command": {
                "action": "sendInput",
                "input": "\n"
            },
            "id": "User.sendInput.LF_U000A"
        },
        {
            "command": {
                "action": "sendInput",
                "input": "\r"
            },
            "id": "User.sendInput.CR_U000D"
        }
    ],
    "keybindings": [
        {
            "id": "User.sendInput.LF_U000A",
            "keys": "shift+enter"
        },
        {
            "id": "User.sendInput.CR_U000D",
            "keys": "ctrl+enter",
            "profile": "{your-wsl-profile-guid}"
        },
        {
            "id": "User.sendInput.LF_U000A",
            "keys": "enter",
            "profile": "{your-wsl-profile-guid}"
        }
    ]
}
```
