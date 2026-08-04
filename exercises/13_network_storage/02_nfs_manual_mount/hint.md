`mount -t nfs 127.0.0.1:/srv/nfsshare /mnt/nfsclient` mounts it directly (the
`-t nfs` is optional -- `mount` can usually infer it from the `host:/path`
syntax). `findmnt /mnt/nfsclient` (or plain `mount | grep nfsclient`) shows
what's actually mounted there.
