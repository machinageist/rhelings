#!/usr/bin/env bash
# Pass condition: rhelings-demo's effective unit config lists
# network-online.target in both After= and Wants=, and the service is still
# active after the reload+restart this requires.
set -uo pipefail

after="$(systemctl show rhelings-demo -p After --value)"
wants="$(systemctl show rhelings-demo -p Wants --value)"
echo "After: ${after}"
echo "Wants: ${wants}"

if ! echo "${after}" | grep -qw 'network-online.target'; then
    echo "network-online.target is not in After=."
    exit 1
fi

if ! echo "${wants}" | grep -qw 'network-online.target'; then
    echo "network-online.target is not in Wants=."
    exit 1
fi

active="$(systemctl is-active rhelings-demo)"
echo "is-active: ${active}"
if [ "${active}" != "active" ]; then
    echo "rhelings-demo is not active -- did daemon-reload + restart happen after the edit?"
    exit 1
fi

echo "Dependency tree:"
systemctl list-dependencies rhelings-demo --no-pager || true

exit 0
