#!/usr/bin/env bash
# Idempotent: turns httpd_can_network_connect off, persistently, so there's
# something to fix.
set -euo pipefail

setsebool -P httpd_can_network_connect off
