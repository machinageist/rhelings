#!/usr/bin/env bash
# Idempotent: appends a bad fstab entry (a UUID that doesn't correspond to
# any real filesystem, no nofail) so the NEXT boot drops to emergency mode --
# strips any previous rhelings-added bad entry first so re-running this
# doesn't stack up duplicates. Stashes the current boot id so check.sh can
# tell whether a reboot has happened since setup ran.
set -euo pipefail

STASH_DIR="/var/tmp/rhelings"
mkdir -p "${STASH_DIR}"

sed -i '/# rhelings-lab-bad-entry/d' /etc/fstab

echo "UUID=00000000-0000-0000-0000-000000000000  /mnt/does-not-exist  xfs  defaults  0  2  # rhelings-lab-bad-entry" >> /etc/fstab

cat /proc/sys/kernel/random/boot_id > "${STASH_DIR}/02_fix_boot_failure_bad_fstab.boot_id"

echo "Bad fstab entry added. The NEXT boot will drop to emergency mode until it's fixed."
