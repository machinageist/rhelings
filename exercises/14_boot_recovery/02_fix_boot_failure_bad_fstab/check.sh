#!/usr/bin/env bash
# Reboot-kind check: first confirms a real reboot happened since setup ran,
# THEN checks that the system reached a normal target (not emergency/rescue)
# and that the bad fstab entry is gone.
set -uo pipefail

STASH_FILE="/var/tmp/rhelings/02_fix_boot_failure_bad_fstab.boot_id"

if [ ! -f "${STASH_FILE}" ]; then
    echo "No stashed boot id found -- re-run setup (r) first."
    exit 1
fi

stashed_boot_id="$(cat "${STASH_FILE}")"
current_boot_id="$(cat /proc/sys/kernel/random/boot_id)"

if [ "${stashed_boot_id}" = "${current_boot_id}" ]; then
    echo "You haven't rebooted yet. Reboot now to actually see the emergency-mode failure."
    exit 1
fi

target="$(systemctl get-default)"
active_target="$(systemctl list-units --type=target --state=active --no-legend 2>/dev/null | awk '{print $1}' | grep -E '^(multi-user|graphical)\.target$' | head -1)"

echo "Default target: ${target}"
echo "Currently active normal target: ${active_target:-<none>}"

ok=1

if [ -z "${active_target}" ]; then
    echo "The system does not appear to have reached multi-user.target or graphical.target."
    ok=0
fi

if grep -q 'rhelings-lab-bad-entry' /etc/fstab; then
    echo "The bad fstab entry is still present -- remove the line referencing the nonexistent filesystem."
    ok=0
fi

[ "${ok}" -eq 1 ]
