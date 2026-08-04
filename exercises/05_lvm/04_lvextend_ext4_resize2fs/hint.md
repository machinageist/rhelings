```sh
lvextend -L +200M /dev/mapper/vg_data04-lv_ext401
resize2fs /dev/mapper/vg_data04-lv_ext401
```

`resize2fs` takes the **device**, not the mount point -- the opposite of
`xfs_growfs`. With no size argument, it grows to fill the entire underlying
block device, which is exactly what you want right after `lvextend`.

`df -h /mnt/ext4-grow` before and after shows the filesystem-visible size
change; `lvs vg_data04/lv_ext401` shows the LV layer.
