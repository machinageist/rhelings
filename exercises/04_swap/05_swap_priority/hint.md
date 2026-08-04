`swapon --show` has a `PRIO` column showing the current priority of each
active swap device -- default is usually `-2`.

The `pri=` mount option controls priority. It's part of the options field in
`/etc/fstab`, comma-joined with anything else in that field:

```
/swapfile-fast  none  swap  sw,pri=10  0  0
/swapfile-slow  none  swap  sw,pri=5   0  0
```

Editing `/etc/fstab` alone doesn't change what's active right now, though --
you also need to deactivate and reactivate each one (`swapoff` then
`swapon`, or `swapoff -a && swapon -a`) so the new priority actually takes
effect immediately, not just after the next reboot.
