Find your device first:

```sh
cat /var/tmp/rhelings/03_storage_partitions_01_fdisk_new_partition.loopdev
```

Then `fdisk /dev/loopX` (substitute the real path) drops you into an
interactive prompt:

- `n` -- new partition
- `p` -- primary
- Enter -- accept the default partition number (1)
- Enter -- accept the default first sector
- `+500M` -- last sector, sized relative to the first
- `w` -- write the table to disk and exit

`p` (at the top-level prompt, before `w`) shows you the pending partition
table without committing it, if you want to double-check before writing.
