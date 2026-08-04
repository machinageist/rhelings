In the emergency shell:

```sh
mount -o remount,rw /
```

Then edit `/etc/fstab` (`vi /etc/fstab`) and delete the line with the
`# rhelings-lab-bad-entry` marker comment -- or any line pointing at a UUID
that doesn't correspond to anything real.

```sh
reboot
```

Adding `nofail` as a mount option is a real alternative fix for a
*legitimately* optional filesystem (one that's fine to skip if it's not
there) -- but that's not this case. This entry doesn't correspond to
anything real at all, so removing it outright is the correct fix, not
papering over it with `nofail`.

Once you're back at a normal login, `systemctl get-default` and
`systemctl list-units --type=target --state=active` confirm you're at
multi-user (or graphical), not emergency/rescue.
