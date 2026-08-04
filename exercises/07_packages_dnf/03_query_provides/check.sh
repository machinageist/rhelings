#!/usr/bin/env bash
# Pass condition: psmisc is installed and the killall command is on PATH.
set -uo pipefail

if ! rpm -q psmisc >/dev/null 2>&1; then
    echo "psmisc is not installed."
    exit 1
fi

if ! command -v killall >/dev/null 2>&1; then
    echo "psmisc is installed but killall is still not on PATH."
    exit 1
fi

echo "psmisc is installed and killall is available: $(command -v killall)"
exit 0
