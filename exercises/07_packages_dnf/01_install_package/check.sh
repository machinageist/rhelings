#!/usr/bin/env bash
# Pass condition: the `tree` package is installed.
set -uo pipefail

if rpm -q tree >/dev/null 2>&1; then
    echo "tree is installed: $(rpm -q tree)"
    exit 0
fi

echo "tree is not installed."
exit 1
