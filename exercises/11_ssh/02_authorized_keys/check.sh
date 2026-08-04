#!/usr/bin/env bash
# Pass condition: rhelings-alice's authorized_keys contains the staged
# teammate key, with correct ownership and permissions on the .ssh directory
# and the file itself.
set -uo pipefail

USER_NAME="rhelings-alice"
HOME_DIR="/home/${USER_NAME}"
AUTH="${HOME_DIR}/.ssh/authorized_keys"
STAGED_PUB="/root/rhelings-11-02-staged/teammate_key.pub"

if [ ! -f "${STAGED_PUB}" ]; then
    echo "Staged key ${STAGED_PUB} missing -- press 'r' to reset this exercise."
    exit 1
fi

if [ ! -f "${AUTH}" ]; then
    echo "${AUTH} does not exist."
    exit 1
fi

expected_key="$(awk '{print $2}' "${STAGED_PUB}")"
if ! grep -qF "${expected_key}" "${AUTH}"; then
    echo "${AUTH} does not contain the staged teammate key."
    exit 1
fi

dir_perms="$(stat -c '%a' "${HOME_DIR}/.ssh")"
file_perms="$(stat -c '%a' "${AUTH}")"
owner="$(stat -c '%U:%G' "${AUTH}")"
echo ".ssh perms: ${dir_perms}, authorized_keys perms: ${file_perms}, owner: ${owner}"

if [ "${dir_perms}" != "700" ]; then
    echo ".ssh directory must be 700."
    exit 1
fi

if [ "${file_perms}" != "600" ]; then
    echo "authorized_keys must be 600."
    exit 1
fi

if [ "${owner}" != "${USER_NAME}:${USER_NAME}" ]; then
    echo "authorized_keys must be owned by ${USER_NAME}."
    exit 1
fi

exit 0
