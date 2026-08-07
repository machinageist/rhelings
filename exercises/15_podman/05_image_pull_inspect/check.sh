#!/usr/bin/env bash
# Pass condition: the httpd:2.4 image is present in rhelings-podman's rootless
# image store, and the answer file records the port that image declares as
# exposed.
set -uo pipefail

ANSWER_FILE="/home/rhelings-podman/rhelings-15-05-exposed-port.txt"

if ! id rhelings-podman >/dev/null 2>&1; then
    echo "rhelings-podman user missing -- press 'r' to reset this exercise."
    exit 1
fi

UID_RP="$(id -u rhelings-podman)"
RUNTIME="/run/user/${UID_RP}"

if ! sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman image exists docker.io/library/httpd:2.4; then
    echo "docker.io/library/httpd:2.4 is not in rhelings-podman's image store. Images present:"
    sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman images 2>&1 || true
    exit 1
fi

if [ ! -f "${ANSWER_FILE}" ]; then
    echo "${ANSWER_FILE} does not exist yet."
    exit 1
fi

answer="$(tr -d '[:space:]' < "${ANSWER_FILE}")"
echo "recorded port: ${answer}"

if [ "${answer}" != "80" ]; then
    echo "That is not the port this image declares. Look at the .Config.ExposedPorts"
    echo "field of 'podman image inspect', and record digits only."
    exit 1
fi

exit 0
