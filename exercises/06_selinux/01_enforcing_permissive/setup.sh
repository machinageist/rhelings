#!/usr/bin/env bash
# Idempotent: puts SELinux into Permissive mode at runtime so there's something
# to fix. Safe to run repeatedly.
set -euo pipefail

setenforce 0
