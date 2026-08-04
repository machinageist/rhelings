#!/usr/bin/env bash
# Pass condition: SELinux is currently running in Enforcing mode.
set -euo pipefail

mode="$(getenforce)"
echo "Current mode: ${mode}"

if [ "${mode}" = "Enforcing" ]; then
    exit 0
fi

echo "Expected Enforcing, got ${mode}."
exit 1
