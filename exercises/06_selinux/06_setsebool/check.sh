#!/usr/bin/env bash
# Pass condition: httpd_can_network_connect is "on" both right now AND as the
# persisted default -- i.e. set with `-P`, not just for the current boot.
set -uo pipefail

line="$(semanage boolean -l | grep '^httpd_can_network_connect ')"
echo "${line}"

if echo "${line}" | grep -qE '\(\s*on\s*,\s*on\s*\)'; then
    exit 0
fi

echo "Expected httpd_can_network_connect to show (on , on) -- current and persisted."
exit 1
