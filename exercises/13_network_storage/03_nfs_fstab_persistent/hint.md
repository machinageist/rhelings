An `/etc/fstab` line for this looks like:

```
127.0.0.1:/srv/nfsshare  /mnt/nfsclient  nfs  defaults  0 0
```

Once that's in place, `mount /mnt/nfsclient` (no source needed -- `mount`
reads it straight from fstab) is the real test that the entry is actually
correct, not just present.
