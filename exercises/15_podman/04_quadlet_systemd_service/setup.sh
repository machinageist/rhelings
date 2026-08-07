#!/usr/bin/env bash
# Idempotent: installs podman, makes sure the rhelings-podman test user exists
# with linger and a live user systemd instance/runtime dir, creates the rootless
# Quadlet unit directory, then tears down whatever a previous attempt left -- the
# generated service, the container, and the .container file the learner writes.
set -euo pipefail

dnf install -y podman >/dev/null 2>&1 || true

id rhelings-podman >/dev/null 2>&1 || useradd -m rhelings-podman
loginctl enable-linger rhelings-podman >/dev/null 2>&1 || true

UID_RP="$(id -u rhelings-podman)"
systemctl start "user@${UID_RP}.service" >/dev/null 2>&1 || true

RUNTIME="/run/user/${UID_RP}"
BUS="unix:path=${RUNTIME}/bus"
QUADLET_DIR="/home/rhelings-podman/.config/containers/systemd"

mkdir -p "${QUADLET_DIR}"
chown -R rhelings-podman:rhelings-podman /home/rhelings-podman/.config

sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" DBUS_SESSION_BUS_ADDRESS="${BUS}" \
    systemctl --user stop rhelings-quadlet.service >/dev/null 2>&1 || true

sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" \
    podman rm -f rhelings-quadlet >/dev/null 2>&1 || true

rm -f "${QUADLET_DIR}/rhelings-quadlet.container"

sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" DBUS_SESSION_BUS_ADDRESS="${BUS}" \
    systemctl --user daemon-reload >/dev/null 2>&1 || true
