Set `PermitRootLogin no` in `/etc/ssh/sshd_config`. `sshd -t` checks the
config's syntax without touching the running daemon. `sshd -T` prints the
fully-resolved *effective* config (including anything set in
`/etc/ssh/sshd_config.d/*.conf` drop-ins, which can override the main file) --
that's the more reliable way to confirm what's actually in effect, rather
than just grepping the main file.
