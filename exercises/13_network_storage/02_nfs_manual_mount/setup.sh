#!/usr/bin/env bash
# Idempotent: (re)establishes the local NFS export from scratch (this
# exercise doesn't depend on exercise 01 having run) and makes sure
# /mnt/nfsclient exists and is NOT currently mounted.
set -euo pipefail

dnf install -y nfs-utils >/dev/null 2>&1 || true

mkdir -p /srv/nfsshare
echo "nfs export test content" > /srv/nfsshare/hello.txt

touch /etc/exports
grep -qE '^/srv/nfsshare' /etc/exports || echo "/srv/nfsshare  127.0.0.1(ro,sync)" >> /etc/exports

systemctl enable --now nfs-server >/dev/null 2>&1
exportfs -ra

mkdir -p /mnt/nfsclient
mountpoint -q /mnt/nfsclient && umount /mnt/nfsclient || true
