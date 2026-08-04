# Boot & Recovery: reset a forgotten root password

Root's password on this box has just been scrambled to something nobody
knows -- simulating the classic "the person who knew it left, and nobody
wrote it down" scenario. You're still logged into this shell as root right
now (that's what's letting `rhelings` keep running), but for this exercise,
actually go through the real recovery procedure instead of just changing
root's password from where you're already sitting -- the point is the
`rd.break` mechanics, not just the end state.

**Task:**

1. **Reboot the machine.**
2. At the GRUB menu, interrupt the boot (press `e` on the default boot
   entry) and append `rd.break` to the end of the kernel command line (the
   line starting with `linux` or `linux16`), then boot it (`Ctrl+X` or
   `F10`).
3. You'll land in a minimal environment with the real root filesystem
   mounted read-only at `/sysroot`. `chroot` into it, remount `/` read-write
   from inside the chroot, and run `passwd root`. Set root's password to
   exactly: `RhcsaLab123!`
4. **Before rebooting again**, run `touch /.autorelabel`. This is the part
   that's easy to skip and easy to get burned by: anything you create or
   modify from inside the `rd.break` environment doesn't have a proper
   SELinux label yet (the environment is too minimal to apply one), and
   `/etc/shadow` is exactly the kind of file SELinux cares about. Without
   forcing a full relabel on the next boot, a mislabeled `/etc/shadow` can
   itself block logins -- a self-inflicted second lockout on top of the one
   you just fixed.
5. Exit the chroot and reboot normally.
6. Log back in as root with the new password, rerun `rhelings`, and press
   the check key.

**Why this task checks a specific known password instead of just a marker
file:** touching a marker file after recovery would only prove you could
reach a root shell somehow -- it wouldn't prove you actually reset the
*password*, which is the real exam task. This check reads the resulting hash
out of `/etc/shadow` and verifies it matches `RhcsaLab123!` exactly, which is
a real (if narrow) proxy for "the password was actually changed to the right
value," without ever needing rhelings to know or store a plaintext password
itself.
