`journalctl --vacuum-size=50M` trims what's already on disk right now, but
it's a one-time action -- it doesn't stop the journal from growing back past
that size later. The persistent cap is `SystemMaxUse=50M` in
`/etc/systemd/journald.conf`.
