#!/usr/bin/env bash
# Pass condition: /etc/fstab has a matching nfs entry for /mnt/nfsclient, and
# `mount /mnt/nfsclient` (using only the fstab entry) actually succeeds and
# the exported content is visible.
set -uo pipefail

if ! grep -qE '127\.0\.0\.1:/srv/nfsshare[[:space:]]+/mnt/nfsclient[[:space:]]+nfs' /etc/fstab; then
    echo "/etc/fstab has no matching NFS entry for /mnt/nfsclient:"
    grep nfsclient /etc/fstab || echo "(no matching line)"
    exit 1
fi

umount /mnt/nfsclient >/dev/null 2>&1 || true

if ! mount /mnt/nfsclient; then
    echo "'mount /mnt/nfsclient' (using the fstab entry) failed."
    exit 1
fi

if ! mountpoint -q /mnt/nfsclient; then
    echo "/mnt/nfsclient did not end up mounted."
    exit 1
fi

if [ ! -f /mnt/nfsclient/hello.txt ]; then
    echo "hello.txt not visible through the mount."
    exit 1
fi

exit 0
