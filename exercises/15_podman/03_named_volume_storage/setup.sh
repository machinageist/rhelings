#!/usr/bin/env bash
# Idempotent: makes sure the rhelings-podman test user exists with a live user
# systemd instance/runtime dir, then removes any leftover writer/reader
# containers and the rhelings-vol volume itself, so the exercise starts with no
# volume at all. Containers go first -- a volume still in use cannot be removed.
set -euo pipefail

id rhelings-podman >/dev/null 2>&1 || useradd -m rhelings-podman
loginctl enable-linger rhelings-podman >/dev/null 2>&1 || true

UID_RP="$(id -u rhelings-podman)"
systemctl start "user@${UID_RP}.service" >/dev/null 2>&1 || true

sudo -u rhelings-podman XDG_RUNTIME_DIR="/run/user/${UID_RP}" \
    podman rm -f rhelings-writer rhelings-reader >/dev/null 2>&1 || true

sudo -u rhelings-podman XDG_RUNTIME_DIR="/run/user/${UID_RP}" \
    podman volume rm -f rhelings-vol >/dev/null 2>&1 || true
