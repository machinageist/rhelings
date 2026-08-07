#!/usr/bin/env bash
# Pass condition: rhelings-bind is running with the host data directory
# bind-mounted at /data, and the file written from inside the container is
# readable on the host with the expected content.
set -uo pipefail

DATA_DIR="/home/rhelings-podman/rhelings-15-02-data"
HOST_FILE="${DATA_DIR}/container-wrote-this.txt"

if ! id rhelings-podman >/dev/null 2>&1; then
    echo "rhelings-podman user missing -- press 'r' to reset this exercise."
    exit 1
fi

UID_RP="$(id -u rhelings-podman)"
RUNTIME="/run/user/${UID_RP}"

state="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman inspect rhelings-bind --format '{{.State.Status}}' 2>&1)"
echo "rhelings-bind state: ${state}"

if [ "${state}" != "running" ]; then
    echo "rhelings-bind is not running (as the rhelings-podman user). Current containers:"
    sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman ps -a 2>&1 || true
    exit 1
fi

mounts="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman inspect rhelings-bind --format '{{range .Mounts}}{{.Source}}:{{.Destination}}
{{end}}' 2>&1)"
echo "mounts seen: ${mounts}"

if ! echo "${mounts}" | grep -qx "${DATA_DIR}:/data"; then
    echo "Expected ${DATA_DIR} bind-mounted at /data inside the container."
    exit 1
fi

if [ ! -f "${HOST_FILE}" ]; then
    echo "${HOST_FILE} does not exist on the host -- write it from inside the container."
    exit 1
fi

content="$(cat "${HOST_FILE}")"
echo "host file content: ${content}"

if [ "${content}" != "bind mount works" ]; then
    echo "Expected that file to contain exactly: bind mount works"
    exit 1
fi

exit 0
