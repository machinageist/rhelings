```sh
PART="$(cat /var/tmp/rhelings/04_swap_02_swap_on_loop_partition.partition)"

mkswap "${PART}"
swapon "${PART}"

UUID="$(blkid -s UUID -o value "${PART}")"
echo "UUID=${UUID}  none  swap  sw  0  0" >> /etc/fstab

swapon --show
```
