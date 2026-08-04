After rebooting and landing in the emergency shell (root password required):

```sh
mount -o remount,rw /
vi /etc/fstab
# delete the line ending in "# rhelings-lab-bad-entry"
reboot
```

After logging back in normally:

```sh
systemctl get-default
systemctl list-units --type=target --state=active
grep rhelings-lab-bad-entry /etc/fstab   # should print nothing
```
