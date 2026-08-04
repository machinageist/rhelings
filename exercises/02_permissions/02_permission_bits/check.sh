#!/usr/bin/env bash
# Pass condition: the directory and both files have exactly the specified
# octal modes.
set -uo pipefail

check_mode() {
    local path="$1" expected="$2"
    if [ ! -e "${path}" ]; then
        echo "${path} does not exist -- re-run setup (r) to recreate it."
        return 1
    fi
    local actual
    actual="$(stat -c '%a' "${path}")"
    echo "${path}: expected ${expected}, got ${actual}"
    [ "${actual}" = "${expected}" ]
}

ok=1
check_mode /root/rhelings-lab/secrets 750 || ok=0
check_mode /root/rhelings-lab/secrets/db.env 640 || ok=0
check_mode /root/rhelings-lab/secrets/rotate.sh 750 || ok=0

[ "${ok}" -eq 1 ]
