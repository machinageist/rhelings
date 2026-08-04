Find the new device:

```sh
cat /var/tmp/rhelings/05_lvm_06_vgextend_new_pv.newdev
```

Bring it in as a PV and add it to the existing VG:

```sh
pvcreate /dev/loopX
vgextend vg_data06 /dev/loopX
```

`vgs vg_data06` now shows more free space (`VFree`). Extend the LV to
consume all of it with `-l +100%FREE` (note lowercase `-l`, meaning
extents/percentage, instead of `-L`, meaning an absolute size):

```sh
lvextend -l +100%FREE /dev/mapper/vg_data06-lv_grow
```

Then, same as the other LVM exercises, grow the filesystem on top -- XFS
here, so `xfs_growfs` against the mount point.
