An indirect map has two files. The master map points a base directory at a
map file:

```
# /etc/auto.master.d/rhelings.autofs
/mnt/auto  /etc/auto.rhelings
```

The map file itself defines keys under that base directory:

```
# /etc/auto.rhelings
nfsshare  -ro,soft  127.0.0.1:/srv/nfsshare
```

`systemctl enable --now autofs` (or `systemctl restart autofs` if it's
already enabled) picks up the new maps. Nothing mounts until you actually
touch the path -- `ls /mnt/auto/nfsshare` is enough to trigger it.
