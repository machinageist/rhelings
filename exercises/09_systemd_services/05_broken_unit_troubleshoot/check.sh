#!/usr/bin/env bash
# Pass condition: rhelings-broken.service's ExecStart= now points at a real,
# executable file, and the service is actually active.
set -uo pipefail

UNIT_FILE="/etc/systemd/system/rhelings-broken.service"

exec_line="$(grep '^ExecStart=' "${UNIT_FILE}" | head -1)"
echo "ExecStart line: ${exec_line}"

bin_path="$(echo "${exec_line}" | sed 's/^ExecStart=//' | awk '{print $1}')"

if [ -z "${bin_path}" ] || [ ! -x "${bin_path}" ]; then
    echo "${bin_path:-<empty>} does not exist or is not executable."
    exit 1
fi

active="$(systemctl is-active rhelings-broken)"
echo "is-active: ${active}"

if [ "${active}" != "active" ]; then
    echo "rhelings-broken is not active. Diagnose with:"
    echo "  systemctl status rhelings-broken"
    echo "  journalctl -xeu rhelings-broken"
    exit 1
fi

exit 0
