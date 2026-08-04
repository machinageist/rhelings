#!/usr/bin/env bash
# Idempotent: (re)establishes the local NFS export, installs autofs, and
# removes any prior attempt's master/map files, so there's something to
# configure.
set -euo pipefail

dnf install -y nfs-utils autofs >/dev/null 2>&1 || true

mkdir -p /srv/nfsshare
echo "nfs export test content" > /srv/nfsshare/hello.txt

touch /etc/exports
grep -qE '^/srv/nfsshare' /etc/exports || echo "/srv/nfsshare  127.0.0.1(ro,sync)" >> /etc/exports

systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra

rm -f /etc/auto.master.d/rhelings.autofs /etc/auto.rhelings
systemctl restart autofs >/dev/null 2>&1 || true
