#!/usr/bin/env bash
# Pass condition: the rhelings-vol named volume exists, the container that
# wrote to it is gone, and a second container still reads the file back -- that
# combination is what proves the data outlived the container that created it.
set -uo pipefail

if ! id rhelings-podman >/dev/null 2>&1; then
    echo "rhelings-podman user missing -- press 'r' to reset this exercise."
    exit 1
fi

UID_RP="$(id -u rhelings-podman)"
RUNTIME="/run/user/${UID_RP}"

if ! sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman volume exists rhelings-vol; then
    echo "No named volume called rhelings-vol. Volumes that do exist:"
    sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman volume ls 2>&1 || true
    exit 1
fi

if sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman container exists rhelings-writer; then
    echo "rhelings-writer still exists -- remove it, so reading the file back actually proves something."
    exit 1
fi

state="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman inspect rhelings-reader --format '{{.State.Status}}' 2>&1)"
echo "rhelings-reader state: ${state}"

if [ "${state}" != "running" ]; then
    echo "rhelings-reader is not running (as the rhelings-podman user). Current containers:"
    sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman ps -a 2>&1 || true
    exit 1
fi

mounts="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman inspect rhelings-reader --format '{{range .Mounts}}{{.Name}}:{{.Destination}}
{{end}}' 2>&1)"
echo "mounts seen: ${mounts}"

if ! echo "${mounts}" | grep -qx "rhelings-vol:/data"; then
    echo "Expected the rhelings-vol volume mounted at /data inside rhelings-reader."
    exit 1
fi

content="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman exec rhelings-reader cat /data/persisted.txt 2>&1)"
echo "read back: ${content}"

if [ "${content}" != "volume survived" ]; then
    echo "Expected /data/persisted.txt to contain exactly: volume survived"
    exit 1
fi

exit 0
