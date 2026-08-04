#!/usr/bin/env bash
# Idempotent: removes any leftover custom fcontext rule for /srv/web from a
# previous attempt, then recreates /srv/web/index.html with the wrong context.
set -euo pipefail

semanage fcontext -d "/srv/web(/.*)?" 2>/dev/null || true

mkdir -p /srv/web
echo "<html><body>hi</body></html>" > /srv/web/index.html
chcon -t tmp_t /srv/web/index.html
