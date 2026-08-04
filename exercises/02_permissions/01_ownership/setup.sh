#!/usr/bin/env bash
# Idempotent: makes sure appsvc user and appteam group exist, and (re)creates
# a small directory tree under /root/rhelings-lab/deploy owned by root:root.
set -euo pipefail

if ! id appsvc >/dev/null 2>&1; then
    useradd -r -M -s /sbin/nologin appsvc
fi

if ! getent group appteam >/dev/null 2>&1; then
    groupadd appteam
fi

rm -rf /root/rhelings-lab/deploy
mkdir -p /root/rhelings-lab/deploy/bin /root/rhelings-lab/deploy/conf
echo "#!/bin/sh" > /root/rhelings-lab/deploy/bin/run.sh
echo "app: config" > /root/rhelings-lab/deploy/conf/app.conf
chown -R root:root /root/rhelings-lab/deploy
