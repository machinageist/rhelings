#!/usr/bin/env bash
# Idempotent: makes sure 8081/tcp is NOT yet mapped to http_port_t, undoing a
# previous pass at this exercise if needed.
set -euo pipefail

semanage port -d -t http_port_t -p tcp 8081 2>/dev/null || true
