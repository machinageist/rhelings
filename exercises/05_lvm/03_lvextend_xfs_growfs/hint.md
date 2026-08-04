```sh
lvextend -L +200M /dev/mapper/vg_data03-lv_xfs01
xfs_growfs /mnt/xfs-grow
```

Note `xfs_growfs` takes the **mount point**, not the device path -- unlike
almost every other storage command in this domain. It only works on a
mounted XFS filesystem (XFS has no offline resize path at all).

`lvs vg_data03/lv_xfs01` shows the LV's current size. `df -h /mnt/xfs-grow`
shows what the filesystem itself thinks its size is -- compare the two before
and after `xfs_growfs` to see the gap close.
