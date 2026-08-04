#!/usr/bin/env bash
# Pass condition: rhelings-demo.service is inactive right now AND disabled
# for future boots.
set -uo pipefail

active="$(systemctl is-active rhelings-demo 2>&1)"
enabled="$(systemctl is-enabled rhelings-demo 2>&1)"
echo "is-active: ${active}, is-enabled: ${enabled}"

if [ "${active}" = "active" ]; then
    echo "rhelings-demo is still running."
    exit 1
fi

if [ "${enabled}" != "disabled" ]; then
    echo "rhelings-demo is still enabled for boot."
    exit 1
fi

exit 0
