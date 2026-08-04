#!/usr/bin/env bash
# Pass condition: the `zsh` package is not installed.
set -uo pipefail

if rpm -q zsh >/dev/null 2>&1; then
    echo "zsh is still installed: $(rpm -q zsh)"
    exit 1
fi

echo "zsh is not installed."
exit 0
