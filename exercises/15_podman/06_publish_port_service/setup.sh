#!/usr/bin/env bash
# Idempotent: installs podman and curl (the check fetches the served page),
# makes sure the rhelings-podman test user exists with a live user systemd
# instance/runtime dir, creates an empty web root for the bind mount, then
# removes any leftover rhelings-web container and the index.html the learner
# has to write.
set -euo pipefail

dnf install -y podman curl >/dev/null 2>&1 || true

id rhelings-podman >/dev/null 2>&1 || useradd -m rhelings-podman
loginctl enable-linger rhelings-podman >/dev/null 2>&1 || true

UID_RP="$(id -u rhelings-podman)"
systemctl start "user@${UID_RP}.service" >/dev/null 2>&1 || true

WEB_DIR="/home/rhelings-podman/rhelings-15-06-web"
mkdir -p "${WEB_DIR}"
chown rhelings-podman:rhelings-podman "${WEB_DIR}"

sudo -u rhelings-podman XDG_RUNTIME_DIR="/run/user/${UID_RP}" \
    podman rm -f rhelings-web >/dev/null 2>&1 || true

rm -f "${WEB_DIR}/index.html"
