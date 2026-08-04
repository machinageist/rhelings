#!/usr/bin/env bash
# Idempotent: creates /srv/nfsshare with test content, removes any existing
# export line for it, and makes sure nfs-server is stopped/disabled, so
# there's something to configure.
set -euo pipefail

dnf install -y nfs-utils >/dev/null 2>&1 || true

mkdir -p /srv/nfsshare
echo "nfs export test content" > /srv/nfsshare/hello.txt

touch /etc/exports
sed -i '\#^/srv/nfsshare#d' /etc/exports

systemctl disable --now nfs-server >/dev/null 2>&1 || true
