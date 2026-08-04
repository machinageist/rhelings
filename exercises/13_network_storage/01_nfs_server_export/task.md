# Network storage: exporting an NFS share

On the real exam you'd typically be pointed at an NFS export that already
exists on some other server. This box stands up its own local NFS server too
(exporting to itself over `127.0.0.1`), so the whole domain is practiceable
without a second VM.

`/srv/nfsshare` exists on this box with some test content, but nothing
exports it yet.

**Task:**

1. Add an entry to `/etc/exports` exporting `/srv/nfsshare` to `127.0.0.1`
   (read-only is fine).
2. Start and enable the NFS server, and make sure the export table actually
   picks up the new entry.
