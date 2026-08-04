#!/usr/bin/env bash
# Idempotent: removes any prior attempt's entry for app-db.internal from
# /etc/hosts, so there's something to add.
set -euo pipefail

sed -i '/app-db\.internal/d' /etc/hosts
