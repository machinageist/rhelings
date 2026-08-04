```sh
LOOPDEV="$(cat /var/tmp/rhelings/03_storage_partitions_02_parted_gpt_partition.loopdev)"

parted -s "${LOOPDEV}" mklabel gpt
parted -s "${LOOPDEV}" mkpart primary 1MiB 100%
partprobe "${LOOPDEV}"

parted -s "${LOOPDEV}" print
lsblk "${LOOPDEV}"
```
