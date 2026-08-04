#!/usr/bin/env bash
# Idempotent: makes sure labtech exists with no sudo access yet -- creates the
# user if missing, removes it from wheel if a previous attempt added it there,
# and clears any leftover drop-in file from a previous attempt.
set -euo pipefail

if ! id labtech >/dev/null 2>&1; then
    useradd -m labtech
fi

gpasswd -d labtech wheel 2>/dev/null || true
rm -f /etc/sudoers.d/labtech
