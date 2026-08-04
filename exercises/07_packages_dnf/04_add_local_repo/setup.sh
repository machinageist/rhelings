#!/usr/bin/env bash
# Idempotent: (re)builds the local vendor repo at /opt/vendor-repo (empty is
# fine -- the point is the repo definition, not its contents) and removes any
# .repo file a previous attempt may have left behind.
set -euo pipefail

dnf install -y createrepo_c >/dev/null 2>&1 || true

mkdir -p /opt/vendor-repo
createrepo_c /opt/vendor-repo >/dev/null 2>&1 || true

rm -f /etc/yum.repos.d/vendor.repo
