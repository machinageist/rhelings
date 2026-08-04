#!/usr/bin/env bash
# Pass condition: 8081/tcp appears in the http_port_t port list.
# Uses a small window after the anchor line since semanage sometimes wraps a
# long port list onto continuation lines.
set -uo pipefail

listing="$(semanage port -l)"

if echo "${listing}" | grep -A3 -E '^http_port_t[[:space:]]' | grep -qw 8081; then
    echo "8081/tcp is mapped to http_port_t:"
    echo "${listing}" | grep -A3 -E '^http_port_t[[:space:]]'
    exit 0
fi

echo "8081/tcp is not yet mapped to http_port_t. Current http_port_t ports:"
echo "${listing}" | grep -A3 -E '^http_port_t[[:space:]]' || true
exit 1
