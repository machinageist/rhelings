#!/usr/bin/env bash
# Pass condition: /etc/exports exports /srv/nfsshare to 127.0.0.1, the
# nfs-server service is active, and the live export table (exportfs -v)
# actually reflects it.
set -uo pipefail

if ! grep -qE '^/srv/nfsshare[[:space:]]+127\.0\.0\.1' /etc/exports; then
    echo "/etc/exports has no entry exporting /srv/nfsshare to 127.0.0.1:"
    cat /etc/exports
    exit 1
fi

if ! systemctl is-active --quiet nfs-server; then
    echo "nfs-server is not active."
    exit 1
fi

if ! exportfs -v | grep -q '/srv/nfsshare'; then
    echo "/srv/nfsshare is not in the live export table (exportfs -v):"
    exportfs -v
    exit 1
fi

echo "/srv/nfsshare is exported to 127.0.0.1 and nfs-server is active."
exit 0
