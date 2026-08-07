#!/usr/bin/env bash
# Pass condition: rhelings-demo is running, as seen through rhelings-podman's
# own (rootless) podman storage.
set -uo pipefail

if ! id rhelings-podman >/dev/null 2>&1; then
    echo "rhelings-podman user missing -- press 'r' to reset this exercise."
    exit 1
fi

UID_RP="$(id -u rhelings-podman)"
RUNTIME="/run/user/${UID_RP}"

state="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman inspect rhelings-demo --format '{{.State.Status}}' 2>&1)"
echo "rhelings-demo state: ${state}"

if [ "${state}" != "running" ]; then
    echo "rhelings-demo is not running (as the rhelings-podman user). Current containers:"
    sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman ps -a 2>&1 || true
    exit 1
fi

exit 0
