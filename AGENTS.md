# AGENTS.md

This repo is a collection of zsh setup scripts and templates. It has no build
system, tests, or dependencies. Validation commands:

## Lint / typecheck

No linter configured. If `shellcheck` is available, run it on the scripts:

```bash
shellcheck install-macos.sh install-ubuntu-wsl.sh
```

## Tests

No test suite. Manual verification only:

```bash
# macOS
bash install-macos.sh

# Ubuntu/WSL2
bash install-ubuntu-wsl.sh
```

## Conventions

- Shell scripts use `#!/bin/bash` with `set -e`.
- Scripts must be idempotent (safe to run multiple times).
- Existing `~/.zshrc` is never overwritten automatically.
- Single source of truth for zsh config is `zshrc-template`; installers copy
  it rather than maintaining inline duplicates.
- Commit messages follow Conventional Commits (`type(scope): subject`).
