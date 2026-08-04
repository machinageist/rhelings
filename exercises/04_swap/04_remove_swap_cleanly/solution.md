```sh
swapoff /swapfile-decom
sed -i '\#swapfile-decom#d' /etc/fstab
rm /swapfile-decom

swapon --show
grep swapfile-decom /etc/fstab   # should print nothing
```
