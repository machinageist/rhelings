#!/usr/bin/env bash
# Pass condition: rhelings-web is running with host port 8080 published to the
# container's port 80, and an HTTP request to localhost:8080 returns the page
# served out of the bind-mounted web root.
set -uo pipefail

WEB_DIR="/home/rhelings-podman/rhelings-15-06-web"
EXPECTED="Welcome to the rhelings container web server"

if ! id rhelings-podman >/dev/null 2>&1; then
    echo "rhelings-podman user missing -- press 'r' to reset this exercise."
    exit 1
fi

UID_RP="$(id -u rhelings-podman)"
RUNTIME="/run/user/${UID_RP}"

if [ ! -f "${WEB_DIR}/index.html" ]; then
    echo "${WEB_DIR}/index.html does not exist yet -- that is the page the container should serve."
    exit 1
fi

state="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman inspect rhelings-web --format '{{.State.Status}}' 2>&1)"
echo "rhelings-web state: ${state}"

if [ "${state}" != "running" ]; then
    echo "rhelings-web is not running (as the rhelings-podman user). Current containers:"
    sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman ps -a 2>&1 || true
    exit 1
fi

ports="$(sudo -u rhelings-podman XDG_RUNTIME_DIR="${RUNTIME}" podman port rhelings-web 2>&1)"
echo "published ports: ${ports}"

if ! echo "${ports}" | grep -q '^80/tcp -> .*:8080$'; then
    echo "Expected host port 8080 published to the container's port 80 (-p 8080:80)."
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "curl is not installed, so the served page cannot be verified."
    exit 1
fi

body="$(curl -fsS --max-time 5 http://127.0.0.1:8080/ 2>&1)"
echo "HTTP response body: ${body}"

if ! echo "${body}" | grep -qF "${EXPECTED}"; then
    echo "Expected the served page to contain: ${EXPECTED}"
    echo "If the request failed outright, check the bind mount has :Z -- without it"
    echo "httpd cannot read the document root and returns a 403."
    exit 1
fi

exit 0
