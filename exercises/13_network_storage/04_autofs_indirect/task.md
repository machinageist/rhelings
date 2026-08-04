# Network storage: autofs with an indirect map

An `fstab` entry mounts an NFS share permanently, whether or not it's ever
used. `autofs` instead mounts it on demand, the first time something touches
the path, and unmounts it again after a period of inactivity.

The local NFS server on this box exports `/srv/nfsshare` to `127.0.0.1`
(already configured by setup).

**Task:**

1. Configure `autofs` with an **indirect map** so that accessing
   `/mnt/auto/nfsshare` automatically mounts `127.0.0.1:/srv/nfsshare`:
   - a master map file under `/etc/auto.master.d/` pointing `/mnt/auto` at a
     map file
   - that map file defining an `nfsshare` key pointing at the NFS export
2. Restart `autofs` and make sure it's enabled.
3. Trigger the mount by accessing the path (e.g. `ls /mnt/auto/nfsshare`)
   before you consider this done -- an indirect map mounts on first access,
   not on `autofs` startup.
