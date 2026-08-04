#!/usr/bin/env bash
# Reboot-kind check: first confirms the boot id actually changed since setup
# ran (i.e. a real reboot happened), THEN checks that the default target is
# multi-user.target. Checking the target before confirming a reboot would let
# a learner "pass" by just running systemctl set-default without ever
# rebooting, which defeats the point of a reboot exercise.
set -uo pipefail

STASH_FILE="/var/tmp/rhelings/01_default_boot_target.boot_id"

if [ ! -f "${STASH_FILE}" ]; then
    echo "No stashed boot id found -- re-run setup (r) first."
    exit 1
fi

stashed_boot_id="$(cat "${STASH_FILE}")"
current_boot_id="$(cat /proc/sys/kernel/random/boot_id)"

if [ "${stashed_boot_id}" = "${current_boot_id}" ]; then
    echo "You haven't rebooted yet. Set the default target, then actually reboot the machine."
    exit 1
fi

target="$(systemctl get-default)"
echo "Default target: ${target}"

if [ "${target}" = "multi-user.target" ]; then
    exit 0
fi

echo "Expected multi-user.target, got ${target}."
exit 1
