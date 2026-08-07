#!/usr/bin/env bash
# Idempotent: makes sure the rhelings-podman test user exists with a live user
# systemd instance/runtime dir, creates the host directory the bind mount will
# point at, and removes any leftover rhelings-bind container and previously
# written file from an earlier attempt.
set -euo pipefail

id rhelings-podman >/dev/null 2>&1 || useradd -m rhelings-podman
loginctl enable-linger rhelings-podman >/dev/null 2>&1 || true

UID_RP="$(id -u rhelings-podman)"
systemctl start "user@${UID_RP}.service" >/dev/null 2>&1 || true

DATA_DIR="/home/rhelings-podman/rhelings-15-02-data"
mkdir -p "${DATA_DIR}"
chown rhelings-podman:rhelings-podman "${DATA_DIR}"

sudo -u rhelings-podman XDG_RUNTIME_DIR="/run/user/${UID_RP}" \
    podman rm -f rhelings-bind >/dev/null 2>&1 || true

rm -f "${DATA_DIR}/container-wrote-this.txt"
