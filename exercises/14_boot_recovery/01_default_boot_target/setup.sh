#!/usr/bin/env bash
# Idempotent: sets the default boot target to graphical.target (the "wrong"
# starting state) and stashes the current boot id so check.sh can tell
# whether a reboot has actually happened since setup ran. Safe to re-run --
# each run overwrites the stashed boot id with whatever boot we're currently
# on.
set -euo pipefail

STASH_DIR="/var/tmp/rhelings"
mkdir -p "${STASH_DIR}"

systemctl set-default graphical.target >/dev/null

cat /proc/sys/kernel/random/boot_id > "${STASH_DIR}/01_default_boot_target.boot_id"

echo "Default target set to graphical.target. Current boot id stashed."
