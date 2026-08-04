Find your partition:

```sh
cat /var/tmp/rhelings/04_swap_02_swap_on_loop_partition.partition
```

`mkswap DEVICE` initializes swap space on a partition, same idea as
`mkswap`ing a file. `swapon DEVICE` activates it immediately.

For the fstab line, get the UUID first (`blkid DEVICE`), then:

```
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  none  swap  sw  0  0
```

Same fstab shape as a swapfile entry -- `none` for the mount point (swap
doesn't mount anywhere in the filesystem tree) and `swap` for the type either
way.
