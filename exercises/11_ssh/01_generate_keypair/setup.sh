#!/usr/bin/env bash
# Idempotent: makes sure rhelings-alice exists and has no keypair yet, so
# there's something to generate.
set -euo pipefail

id rhelings-alice >/dev/null 2>&1 || useradd -m rhelings-alice

rm -f /home/rhelings-alice/.ssh/id_ed25519 /home/rhelings-alice/.ssh/id_ed25519.pub
