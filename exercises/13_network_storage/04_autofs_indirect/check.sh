#!/usr/bin/env bash
# Pass condition: accessing /mnt/auto/nfsshare triggers an automount that
# actually surfaces the exported content, and autofs is enabled for boot.
set -uo pipefail

# Trigger the automount -- indirect maps mount on first access, not at
# autofs startup.
ls /mnt/auto/nfsshare >/dev/null 2>&1
sleep 1

if ! mount | grep -q '/mnt/auto/nfsshare'; then
    echo "/mnt/auto/nfsshare is not mounted. Current autofs status:"
    systemctl status autofs --no-pager | head -20
    exit 1
fi

if [ ! -f /mnt/auto/nfsshare/hello.txt ]; then
    echo "hello.txt not visible under /mnt/auto/nfsshare -- wrong map target?"
    exit 1
fi

if ! systemctl is-enabled --quiet autofs; then
    echo "autofs is not enabled -- this should survive a reboot."
    exit 1
fi

exit 0
