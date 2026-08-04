#!/usr/bin/env bash
# Pass condition: a mode-600 credentials file exists, /mnt/smbclient is
# mounted as a cifs filesystem, and the share's content is actually visible
# through it.
set -uo pipefail

CREDFILE="/root/.rhelings-13-05-credentials"

if [ ! -f "${CREDFILE}" ]; then
    echo "${CREDFILE} does not exist yet."
    exit 1
fi

perms="$(stat -c '%a' "${CREDFILE}")"
if [ "${perms}" != "600" ]; then
    echo "${CREDFILE} should be mode 600 (it contains a password), found ${perms}."
    exit 1
fi

if ! mountpoint -q /mnt/smbclient; then
    echo "/mnt/smbclient is not currently mounted."
    exit 1
fi

fstype="$(findmnt -n -o FSTYPE /mnt/smbclient)"
echo "mounted fstype: ${fstype}"
case "${fstype}" in
    cifs*) ;;
    *)
        echo "Expected a cifs filesystem, got: ${fstype}"
        exit 1
        ;;
esac

if [ ! -f /mnt/smbclient/hello.txt ]; then
    echo "hello.txt not visible through the mount."
    exit 1
fi

exit 0
