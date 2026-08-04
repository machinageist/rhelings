#!/usr/bin/env bash
# Pass condition: a NetworkManager connection profile bound to dummy0 exists
# with ipv4.method=manual and 192.0.2.10/24 among its addresses. Checks the
# saved profile config, not live interface state (activation is a later
# exercise).
set -uo pipefail

profile="$(nmcli -t -f NAME,DEVICE connection show 2>/dev/null | awk -F: '$2 == "dummy0" { print $1; exit }')"

if [ -z "${profile}" ]; then
    echo "No connection profile bound to dummy0 found."
    nmcli -t -f NAME,DEVICE connection show
    exit 1
fi

echo "Found profile: ${profile}"

method="$(nmcli -g ipv4.method connection show "${profile}")"
echo "ipv4.method: ${method}"
if [ "${method}" != "manual" ]; then
    echo "Expected ipv4.method=manual."
    exit 1
fi

addresses="$(nmcli -g ipv4.addresses connection show "${profile}")"
echo "ipv4.addresses: ${addresses}"
if ! echo "${addresses}" | grep -qw '192\.0\.2\.10/24'; then
    echo "Expected 192.0.2.10/24 among the profile's addresses."
    exit 1
fi

exit 0
