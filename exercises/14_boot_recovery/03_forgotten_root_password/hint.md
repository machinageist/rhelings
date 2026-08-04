GRUB menu: highlight the boot entry, press `e` to edit. Find the line
starting with `linux` (or `linux16`), go to the end of it, and add a space
followed by `rd.break`. Then `Ctrl+X` (or `F10`) to boot with that change --
it's one-time only, not saved.

In the `rd.break` shell, the real root filesystem is mounted read-only at
`/sysroot`:

```sh
chroot /sysroot
mount -o remount,rw /
passwd root
# enter RhcsaLab123! twice
touch /.autorelabel
exit
exit
```

(Two `exit`s: one to leave the chroot, one to leave the `rd.break` shell and
continue booting -- or `reboot -f` if `exit` alone doesn't continue the boot
on your system.)

`/.autorelabel` forces a full SELinux relabel on the next boot -- it's a flag
file, not a command, and it disappears automatically once the relabel runs.
Skip it and a mislabeled `/etc/shadow` can block logins even with the right
password.
