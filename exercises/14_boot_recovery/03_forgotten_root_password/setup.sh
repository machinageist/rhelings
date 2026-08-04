#!/usr/bin/env bash
# Idempotent: scrambles root's password to a random, discarded string (never
# stashed anywhere -- the whole point is that nobody knows it) and stashes
# the current boot id so check.sh can tell whether a reboot has happened
# since setup ran. Safe to re-run -- each run re-scrambles the password and
# re-stashes the current boot id.
set -euo pipefail

STASH_DIR="/var/tmp/rhelings"
mkdir -p "${STASH_DIR}"

random_password="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32)"
echo "root:${random_password}" | chpasswd

cat /proc/sys/kernel/random/boot_id > "${STASH_DIR}/03_forgotten_root_password.boot_id"

echo "root's password has been scrambled to an unknown value. Recover it via rd.break, then reboot."
