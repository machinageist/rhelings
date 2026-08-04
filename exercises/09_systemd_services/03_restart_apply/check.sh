#!/usr/bin/env bash
# Pass condition: rhelings-demo is active, and its activation timestamp is
# LATER than the one setup.sh recorded -- proof the unit was actually
# restarted, not just left running since setup.
set -uo pipefail

MARKER="/var/tmp/rhelings-09-03-marker"

if [ ! -f "${MARKER}" ]; then
    echo "Setup marker missing -- press 'r' to reset this exercise first."
    exit 1
fi

before="$(cat "${MARKER}")"
after="$(systemctl show rhelings-demo -p ActiveEnterTimestampMonotonic --value)"
active="$(systemctl is-active rhelings-demo)"

echo "is-active: ${active}"
echo "Activation timestamp -- before: ${before}, now: ${after}"

if [ "${active}" != "active" ]; then
    echo "Service is not active."
    exit 1
fi

if [ "${after}" = "${before}" ]; then
    echo "Activation timestamp hasn't changed -- the service hasn't been restarted since setup ran."
    exit 1
fi

exit 0
