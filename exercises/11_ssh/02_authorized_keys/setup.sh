#!/usr/bin/env bash
# Idempotent: makes sure rhelings-alice exists, stages a "teammate" keypair
# to install a public key from, and wipes her .ssh directory so there's
# nothing already wired up.
set -euo pipefail

id rhelings-alice >/dev/null 2>&1 || useradd -m rhelings-alice

STAGE_DIR="/root/rhelings-11-02-staged"
mkdir -p "${STAGE_DIR}"
if [ ! -f "${STAGE_DIR}/teammate_key" ]; then
    ssh-keygen -t ed25519 -N '' -f "${STAGE_DIR}/teammate_key" -C "teammate@example.com" -q
fi

rm -rf /home/rhelings-alice/.ssh
