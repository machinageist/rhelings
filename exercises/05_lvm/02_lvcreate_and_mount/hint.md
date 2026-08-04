`lvcreate -n NAME -L SIZE VG` creates a logical volume of an exact size:

```sh
lvcreate -n lv_app -L 300M vg_data02
```

Every LV gets a stable path at `/dev/mapper/VG-LV` (here,
`/dev/mapper/vg_data02-lv_app`) as soon as it's created -- format and mount
that path, not a raw loop device path:

```sh
mkfs.xfs /dev/mapper/vg_data02-lv_app
```

fstab entry, same shape as any other filesystem mount:

```
/dev/mapper/vg_data02-lv_app  /mnt/app-data  xfs  defaults  0  0
```

Then `mount -a` (or `mount /mnt/app-data` directly) to activate it now.
