#!/usr/bin/env bash
# Idempotent: makes sure 203.0.113.0/24 is NOT bound as a source to the
# internal zone yet, so there's something to add. Doesn't touch interfaces.
set -euo pipefail

firewall-cmd --permanent --zone=internal --remove-source=203.0.113.0/24 >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null
