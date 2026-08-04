Find your partition:

```sh
cat /var/tmp/rhelings/03_storage_partitions_04_format_ext4.partition
```

`mkfs.ext4 -L LABEL DEVICE` creates an ext4 filesystem with a label in one
step (ext4 labels can be up to 16 characters).

`blkid DEVICE` shows the resulting `TYPE=` and `LABEL=` once it's formatted.
