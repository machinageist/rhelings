# Network storage: a persistent NFS mount via fstab

A manual `mount` command doesn't survive a reboot. The local NFS server on
this box exports `/srv/nfsshare` to `127.0.0.1`, and `/mnt/nfsclient` exists
as a mount point but nothing is mounted or configured yet.

**Task:**

Add an entry to `/etc/fstab` that mounts `127.0.0.1:/srv/nfsshare` at
`/mnt/nfsclient` on boot, then confirm it actually works by mounting it
straight from `fstab` (`mount /mnt/nfsclient`, no manual source/target
needed once fstab has the entry).
