Find your device:

```sh
cat /var/tmp/rhelings/03_storage_partitions_02_parted_gpt_partition.loopdev
```

`parted -s DEVICE mklabel gpt` creates a GPT partition table with no prompts.

`parted -s DEVICE mkpart primary 1MiB 100%` creates one partition spanning
from 1MiB in (leaving room for GPT metadata/alignment) to the end of the disk.
Both commands can be chained on one `parted -s` invocation.

`parted DEVICE print` (no `-s` needed just to view) shows the current
partition table type and layout.
