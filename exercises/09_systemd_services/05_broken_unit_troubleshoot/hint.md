`systemctl status rhelings-broken` will show `status=203/EXEC` in the failure
line -- that specific code means systemd couldn't even execve() the binary,
almost always because the path in `ExecStart=` is wrong or not executable.
`journalctl -xeu rhelings-broken` gives the same story with more context.

Point `ExecStart=` at something that actually exists and is executable (for
example `/usr/bin/sleep infinity`), then `systemctl daemon-reload` and
`systemctl restart rhelings-broken`.
