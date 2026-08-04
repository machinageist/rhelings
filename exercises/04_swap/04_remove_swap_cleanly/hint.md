Order matters: deactivate before deleting the file, or `swapoff` won't have
anything to point at.

```sh
swapoff /swapfile-decom
```

Then edit `/etc/fstab` to remove its line (a text editor, or
`sed -i '\#swapfile-decom#d' /etc/fstab`), then:

```sh
rm /swapfile-decom
```
