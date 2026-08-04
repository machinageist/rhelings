#!/usr/bin/env bash
# Pass condition: nmap-ncat is not installed (undone via dnf history undo).
set -uo pipefail

if rpm -q nmap-ncat >/dev/null 2>&1; then
    echo "nmap-ncat is still installed: $(rpm -q nmap-ncat)"
    echo "Find its transaction with: dnf history list nmap-ncat"
    exit 1
fi

echo "nmap-ncat is not installed."
exit 0
