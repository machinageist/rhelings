Edit `/etc/systemd/journald.conf` and set `Storage=persistent` (uncomment the
line if it's commented out). Then `systemctl restart systemd-journald` --
journald creates `/var/log/journal` itself once persistent storage is
active, you don't need to `mkdir` it.
