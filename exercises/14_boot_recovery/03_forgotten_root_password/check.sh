#!/usr/bin/env bash
# Reboot-kind check: first confirms a real reboot happened since setup ran,
# THEN verifies root's current /etc/shadow hash matches the known target
# password (RhcsaLab123!) by extracting the salt+algorithm actually in use
# from the live hash and recomputing with openssl passwd, rather than
# assuming a specific hash format -- this works regardless of which crypt
# scheme the system's passwd/chpasswd defaults to.
set -uo pipefail

STASH_FILE="/var/tmp/rhelings/03_forgotten_root_password.boot_id"
TARGET_PASSWORD="RhcsaLab123!"

if [ ! -f "${STASH_FILE}" ]; then
    echo "No stashed boot id found -- re-run setup (r) first."
    exit 1
fi

stashed_boot_id="$(cat "${STASH_FILE}")"
current_boot_id="$(cat /proc/sys/kernel/random/boot_id)"

if [ "${stashed_boot_id}" = "${current_boot_id}" ]; then
    echo "You haven't rebooted yet. Go through the rd.break recovery procedure, then reboot."
    exit 1
fi

shadow_hash="$(getent shadow root | cut -d: -f2)"

if [ -z "${shadow_hash}" ] || [ "${shadow_hash}" = "!" ] || [ "${shadow_hash}" = "!!" ] || [ "${shadow_hash}" = "*" ]; then
    echo "root has no usable password hash set (got '${shadow_hash}')."
    exit 1
fi

# Hash format is $ID$SALT$HASH -- field 2 of that (split on '$') is the salt,
# field 1 is the algorithm id. Recompute with the same id+salt and compare
# the full hash string.
algo_id="$(echo "${shadow_hash}" | cut -d'$' -f2)"
salt="$(echo "${shadow_hash}" | cut -d'$' -f3)"

recomputed="$(openssl passwd "-${algo_id}" -salt "${salt}" "${TARGET_PASSWORD}" 2>&1)"

if [ "${recomputed}" = "${shadow_hash}" ]; then
    echo "root's password matches the expected recovery value."
    exit 0
fi

echo "root's password does not match the expected value. Did you set it to exactly: ${TARGET_PASSWORD}"
exit 1
