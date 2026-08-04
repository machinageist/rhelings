#!/usr/bin/env bash
# Pass condition: swapon --show reports priority 10 for /swapfile-fast and 5
# for /swapfile-slow RIGHT NOW, and /etc/fstab has pri=10 / pri=5 in the
# options field for each -- current state alone isn't enough, since a runtime
# -p flag doesn't survive reboot.
set -uo pipefail

ok=1

check_active_priority() {
    local file="$1" expected="$2"
    local line
    line="$(swapon --show=NAME,PRIO --noheadings | awk -v f="${file}" '$1 == f')"
    if [ -z "${line}" ]; then
        echo "${file} is not currently active as swap."
        return 1
    fi
    local prio
    prio="$(echo "${line}" | awk '{print $2}')"
    echo "${file} active priority: ${prio} (expected ${expected})"
    [ "${prio}" = "${expected}" ]
}

check_fstab_priority() {
    local file="$1" expected="$2"
    local line
    line="$(grep -E "^${file}[[:space:]]" /etc/fstab || true)"
    if [ -z "${line}" ]; then
        echo "No /etc/fstab entry for ${file}."
        return 1
    fi
    echo "fstab: ${line}"
    echo "${line}" | grep -qE "pri=${expected}(,|$|[[:space:]])"
}

check_active_priority /swapfile-fast 10 || ok=0
check_active_priority /swapfile-slow 5 || ok=0
check_fstab_priority /swapfile-fast 10 || ok=0
check_fstab_priority /swapfile-slow 5 || ok=0

[ "${ok}" -eq 1 ]
