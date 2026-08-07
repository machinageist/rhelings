#!/usr/bin/env bash
# Pass condition: a Quadlet .container unit exists in the user's Quadlet
# directory, systemd generated a service from it that is active, the container
# it manages is running, and linger is on so it would also come back at boot.
set -uo pipefail

QUADLET_FILE="/home/rhelings-podman/.config/containers/systemd/rhelings-quadlet.container"

if ! id rhelings-podman >/dev/null 2>&1; then
    echo "rhelings-podman user missing -- press 'r' to reset this exercise."
    exit 1
fi

UID_RP="$(id -u rhelings-podman)"
RUNTIME="/run/user/${UID_RP}"
BUS="unix:path=${RUNTIME}/bus"

if [ ! -f "${QUADLET_FILE}" ]; then
    echo "${QUADLET_FILE} does not exist yet."
    exit 1
fi

if ! grep -q '^\[Container\]' "${QUADLET_FILE}"; then
    echo "${QUADLET_FILE} has no [Container] section -- that section is what makes it a Quadlet unit."
    exit 1
fi

active="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" DBUS_SESSION_BUS_ADDRESS="${BUS}" \
    systemctl --user is-active rhelings-quadlet.service 2>&1)"
echo "rhelings-quadlet.service is-active: ${active}"

if [ "${active}" != "active" ]; then
    echo "The generated service is not active. Writing the file is not enough --"
    echo "'systemctl --user daemon-reload' generates the unit, then start it."
    exit 1
fi

state="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman inspect rhelings-quadlet --format '{{.State.Status}}' 2>&1)"
echo "rhelings-quadlet container state: ${state}"

if [ "${state}" != "running" ]; then
    echo "The service is active but there is no running container named rhelings-quadlet --"
    echo "check the ContainerName= line in the unit."
    exit 1
fi

linger="$(loginctl show-user rhelings-podman --property=Linger 2>&1)"
echo "${linger}"

if [ "${linger}" != "Linger=yes" ]; then
    echo "Linger is off for rhelings-podman, so this would not actually start at boot."
    exit 1
fi

exit 0
