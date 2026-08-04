#!/usr/bin/env bash
# Pass condition: a .repo file defines an enabled "vendor" repo pointing at
# file:///opt/vendor-repo, and dnf's own repo list agrees.
set -uo pipefail

REPO_FILE="/etc/yum.repos.d/vendor.repo"

if [ ! -f "${REPO_FILE}" ]; then
    echo "${REPO_FILE} does not exist."
    exit 1
fi

if ! grep -q '^\[vendor\]' "${REPO_FILE}"; then
    echo "${REPO_FILE} has no [vendor] section:"
    cat "${REPO_FILE}"
    exit 1
fi

if ! grep -qE '^baseurl=file:///opt/vendor-repo/?$' "${REPO_FILE}"; then
    echo "${REPO_FILE} baseurl doesn't point at file:///opt/vendor-repo:"
    cat "${REPO_FILE}"
    exit 1
fi

if ! grep -qx 'enabled=1' "${REPO_FILE}"; then
    echo "${REPO_FILE} does not have enabled=1:"
    cat "${REPO_FILE}"
    exit 1
fi

if ! dnf repolist --enabled 2>/dev/null | grep -qi '^vendor'; then
    echo "dnf repolist --enabled does not show 'vendor' as enabled:"
    dnf repolist --enabled
    exit 1
fi

echo "vendor repo is defined and enabled."
exit 0
