#!/usr/bin/env bash
# Pass condition: the dummy1-manual profile's ipv4.dns includes both
# 198.51.100.1 and 198.51.100.2.
set -uo pipefail

PROFILE="dummy1-manual"

if ! nmcli -t -f NAME connection show | grep -qx "${PROFILE}"; then
    echo "Connection profile ${PROFILE} does not exist -- press 'r' to reset."
    exit 1
fi

dns="$(nmcli -g ipv4.dns connection show "${PROFILE}")"
echo "ipv4.dns: ${dns}"

if echo "${dns}" | grep -q '198\.51\.100\.1' && echo "${dns}" | grep -q '198\.51\.100\.2'; then
    exit 0
fi

echo "Expected both 198.51.100.1 and 198.51.100.2 in ipv4.dns."
exit 1
