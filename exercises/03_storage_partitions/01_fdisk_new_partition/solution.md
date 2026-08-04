```sh
LOOPDEV="$(cat /var/tmp/rhelings/03_storage_partitions_01_fdisk_new_partition.loopdev)"

fdisk "${LOOPDEV}" <<EOF
n
p
1


+500M
w
EOF

lsblk "${LOOPDEV}"
```
