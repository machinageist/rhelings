Add a line to `/etc/exports`:

```
/srv/nfsshare  127.0.0.1(ro,sync)
```

`systemctl enable --now nfs-server` starts and enables the server.
`exportfs -ra` re-reads `/etc/exports` and applies it without a restart.
`exportfs -v` shows what's actually live.
