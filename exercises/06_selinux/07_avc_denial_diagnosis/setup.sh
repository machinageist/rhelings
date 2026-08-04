#!/usr/bin/env bash
# Idempotent: creates /srv/appdata/data.txt with the wrong SELinux context, then
# provokes one real AVC denial by reading it as the httpd_t domain (which policy
# does not allow to read tmp_t-labeled files), so ausearch has something
# genuine to show.
set -euo pipefail

semanage fcontext -d "/srv/appdata(/.*)?" 2>/dev/null || true

mkdir -p /srv/appdata
echo "app data" > /srv/appdata/data.txt
chcon -t tmp_t /srv/appdata/data.txt

# This is SUPPOSED to be denied -- that's the point. Don't fail setup over it.
runcon -t httpd_t -- cat /srv/appdata/data.txt >/dev/null 2>&1 || true
