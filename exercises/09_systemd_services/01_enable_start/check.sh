#!/usr/bin/env bash
# Pass condition: rhelings-demo.service is both active right now AND enabled
# for future boots.
set -uo pipefail

active="$(systemctl is-active rhelings-demo)"
enabled="$(systemctl is-enabled rhelings-demo 2>&1)"
echo "is-active: ${active}, is-enabled: ${enabled}"

if [ "${active}" != "active" ]; then
    echo "rhelings-demo is not currently running."
    exit 1
fi

if [ "${enabled}" != "enabled" ]; then
    echo "rhelings-demo is not enabled for boot."
    exit 1
fi

exit 0
