```sh
lvs vg_data05/lv_gotcha        # already ~500M
df -h /mnt/xfs-gotcha          # still shows the old ~300M
mount | grep xfs-gotcha        # confirms the filesystem type is xfs
```

The LV layer is already correct. The filesystem on top of it is the layer
that's stale. For XFS, that's `xfs_growfs`, run against the **mount point**:

```sh
xfs_growfs /mnt/xfs-gotcha
```

Do not run `lvextend` again -- there's no more resizing to do at that layer,
and it wouldn't fix a filesystem-layer problem anyway.
