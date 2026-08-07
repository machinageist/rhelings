#!/usr/bin/env bash
# Idempotent: makes sure the rhelings-podman test user exists with a live
# user systemd instance/runtime dir (needed for rootless podman to work at
# all outside an interactive login), and removes any leftover rhelings-demo
# container from a previous attempt.
set -euo pipefail

id rhelings-podman >/dev/null 2>&1 || useradd -m rhelings-podman
loginctl enable-linger rhelings-podman >/dev/null 2>&1 || true

UID_RP="$(id -u rhelings-podman)"
systemctl start "user@${UID_RP}.service" >/dev/null 2>&1 || true

sudo -u rhelings-podman XDG_RUNTIME_DIR="/run/user/${UID_RP}" \
    podman rm -f rhelings-demo >/dev/null 2>&1 || true
