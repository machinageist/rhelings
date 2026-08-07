#!/usr/bin/env bash
# Idempotent: installs podman, makes sure the rhelings-podman test user exists
# with a live user systemd instance/runtime dir, then removes the httpd image
# and the answer file so the pull and the inspect both have to be done again.
# The rmi is deliberately not forced -- if a later exercise's container is still
# using the image, leave it alone rather than tearing that exercise down.
set -euo pipefail

dnf install -y podman >/dev/null 2>&1 || true

id rhelings-podman >/dev/null 2>&1 || useradd -m rhelings-podman
loginctl enable-linger rhelings-podman >/dev/null 2>&1 || true

UID_RP="$(id -u rhelings-podman)"
systemctl start "user@${UID_RP}.service" >/dev/null 2>&1 || true

sudo -u rhelings-podman XDG_RUNTIME_DIR="/run/user/${UID_RP}" \
    podman rmi docker.io/library/httpd:2.4 >/dev/null 2>&1 || true

rm -f /home/rhelings-podman/rhelings-15-05-exposed-port.txt
