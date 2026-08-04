#!/usr/bin/env bash
# Pass condition: /swapfile-lab exists, is mode 600, is exactly 256MB, is
# currently active as swap, and has a correct persistent fstab entry.
set -uo pipefail

FILE="/swapfile-lab"
ok=1

if [ ! -e "${FILE}" ]; then
    echo "${FILE} does not exist."
    exit 1
fi

mode="$(stat -c '%a' "${FILE}")"
size_bytes="$(stat -c '%s' "${FILE}")"
expected_bytes=$((256 * 1024 * 1024))

echo "mode=${mode} size=${size_bytes} bytes (expected ${expected_bytes})"

if [ "${mode}" != "600" ]; then
    echo "Expected mode 600, got ${mode} -- swap files should not be world- or group-readable."
    ok=0
fi

if [ "${size_bytes}" != "${expected_bytes}" ]; then
    echo "Expected exactly 256MB (${expected_bytes} bytes)."
    ok=0
fi

if ! swapon --show=NAME --noheadings | grep -qx "${FILE}"; then
    echo "${FILE} is not currently active as swap. Current swap:"
    swapon --show
    ok=0
fi

if ! grep -qE "^${FILE}[[:space:]]" /etc/fstab; then
    echo "/etc/fstab has no entry for ${FILE} -- it won't come back after a reboot."
    ok=0
fi

[ "${ok}" -eq 1 ]
