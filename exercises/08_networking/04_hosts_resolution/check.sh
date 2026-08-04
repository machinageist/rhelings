#!/usr/bin/env bash
# Pass condition: app-db.internal resolves to 192.0.2.50 via the standard
# resolver (getent), which reads /etc/hosts through nsswitch -- not just
# grepping the raw file.
set -uo pipefail

result="$(getent hosts app-db.internal 2>&1)"
echo "getent hosts app-db.internal -> ${result}"

if echo "${result}" | awk '{print $1}' | grep -qx '192\.0\.2\.50'; then
    exit 0
fi

echo "Expected app-db.internal to resolve to 192.0.2.50."
exit 1
