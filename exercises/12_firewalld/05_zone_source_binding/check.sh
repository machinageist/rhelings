#!/usr/bin/env bash
# Pass condition: 203.0.113.0/24 is a permanent source binding for the
# internal zone.
set -uo pipefail

sources="$(firewall-cmd --permanent --zone=internal --list-sources)"
echo "internal zone permanent sources: ${sources}"

if echo "${sources}" | tr ' ' '\n' | grep -qx '203\.0\.113\.0/24'; then
    exit 0
fi

echo "Expected 203.0.113.0/24 among the internal zone's sources."
exit 1
