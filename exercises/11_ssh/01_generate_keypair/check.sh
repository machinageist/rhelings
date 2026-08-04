#!/usr/bin/env bash
# Pass condition: rhelings-alice has an ed25519 keypair at the default
# location, with correct ownership and permissions.
set -uo pipefail

USER_NAME="rhelings-alice"
HOME_DIR="/home/${USER_NAME}"
KEY="${HOME_DIR}/.ssh/id_ed25519"
PUB="${KEY}.pub"

if [ ! -f "${KEY}" ] || [ ! -f "${PUB}" ]; then
    echo "Expected keypair not found at ${KEY} / ${PUB}"
    exit 1
fi

info="$(ssh-keygen -l -f "${PUB}" 2>&1)"
echo "${info}"
if ! echo "${info}" | grep -qi ED25519; then
    echo "Key is not ED25519."
    exit 1
fi

key_perms="$(stat -c '%a' "${KEY}")"
dir_perms="$(stat -c '%a' "${HOME_DIR}/.ssh")"
owner="$(stat -c '%U:%G' "${KEY}")"
echo "key perms: ${key_perms}, .ssh perms: ${dir_perms}, owner: ${owner}"

if [ "${key_perms}" != "600" ]; then
    echo "Private key must be 600."
    exit 1
fi

if [ "${dir_perms}" != "700" ]; then
    echo ".ssh directory must be 700."
    exit 1
fi

if [ "${owner}" != "${USER_NAME}:${USER_NAME}" ]; then
    echo "Key must be owned by ${USER_NAME}."
    exit 1
fi

exit 0
