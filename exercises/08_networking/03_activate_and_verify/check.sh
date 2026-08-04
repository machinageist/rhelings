#!/usr/bin/env bash
# Pass condition: 192.0.2.30/24 is actually applied to dummy2's live state,
# not just saved in the connection profile.
set -uo pipefail

if ! ip -4 addr show dev dummy2 2>/dev/null | grep -qw '192\.0\.2\.30/24'; then
    echo "192.0.2.30/24 is not live on dummy2. Current state:"
    ip -4 addr show dev dummy2 2>&1 || echo "(dummy2 not found)"
    exit 1
fi

echo "192.0.2.30/24 is live on dummy2:"
ip -4 addr show dev dummy2
exit 0
