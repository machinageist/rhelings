At the GRUB menu: `e` on the default entry, append `rd.break` to the `linux`
line, `Ctrl+X` to boot.

In the `rd.break` shell:

```sh
mount -o remount,rw /sysroot
chroot /sysroot
mount -o remount,rw /
passwd root
# New password: RhcsaLab123!
# Retype new password: RhcsaLab123!
touch /.autorelabel
exit
reboot -f
```

After the relabel completes and the system comes back up, log in as root
with `RhcsaLab123!`, rerun `rhelings`, and press the check key.
