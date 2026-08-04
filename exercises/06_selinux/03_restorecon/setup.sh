#!/usr/bin/env bash
# Idempotent: recreates /var/www/html/index.html with the wrong SELinux context
# (tmp_t, as if it had been cp'd in from /tmp with --preserve=context).
set -euo pipefail

mkdir -p /var/www/html
echo "<html><body>hi</body></html>" > /var/www/html/index.html
chcon -t tmp_t /var/www/html/index.html
