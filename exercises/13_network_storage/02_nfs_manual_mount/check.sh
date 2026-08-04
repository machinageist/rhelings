#!/usr/bin/env bash
# Pass condition: /mnt/nfsclient is currently mounted, it's an NFS
# filesystem, and the exported content is actually visible through it.
set -uo pipefail

if ! mountpoint -q /mnt/nfsclient; then
    echo "/mnt/nfsclient is not currently mounted."
    exit 1
fi

fstype="$(findmnt -n -o FSTYPE /mnt/nfsclient)"
source="$(findmnt -n -o SOURCE /mnt/nfsclient)"
echo "mounted: source=${source} fstype=${fstype}"

case "${fstype}" in
    nfs*) ;;
    *)
        echo "Expected an nfs-family filesystem, got: ${fstype}"
        exit 1
        ;;
esac

if [ ! -f /mnt/nfsclient/hello.txt ]; then
    echo "hello.txt not visible through the mount -- wrong export or wrong mount point."
    exit 1
fi

exit 0
