`dd if=/dev/zero of=/swapfile-lab bs=1M count=256` creates an exact-size file
(prefer `dd` over `fallocate` here -- some filesystems handle fallocate'd
swap files inconsistently).

```sh
dd if=/dev/zero of=/swapfile-lab bs=1M count=256
chmod 600 /swapfile-lab
mkswap /swapfile-lab
swapon /swapfile-lab
```

For persistence, add a line to `/etc/fstab`:

```
/swapfile-lab  none  swap  sw  0  0
```

`swapon --show` and `free -h` both show currently-active swap.
