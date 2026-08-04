#!/usr/bin/env bash
# Idempotent: (re)creates secrets/ with wide-open permissions (777/666) so
# there's something to tighten.
set -euo pipefail

mkdir -p /root/rhelings-lab/secrets
echo "DB_PASSWORD=hunter2" > /root/rhelings-lab/secrets/db.env
printf '#!/bin/sh\necho rotating\n' > /root/rhelings-lab/secrets/rotate.sh

chmod 777 /root/rhelings-lab/secrets
chmod 666 /root/rhelings-lab/secrets/db.env
chmod 777 /root/rhelings-lab/secrets/rotate.sh
