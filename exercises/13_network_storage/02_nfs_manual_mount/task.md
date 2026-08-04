# Network storage: manually mounting an NFS share

The local NFS server on this box exports `/srv/nfsshare` to `127.0.0.1`
(already configured by setup). `/mnt/nfsclient` exists as a mount point but
nothing is mounted there yet.

**Task:**

Manually mount `127.0.0.1:/srv/nfsshare` onto `/mnt/nfsclient`. This is a
one-off mount for now, not persistent -- that's the next exercise.
