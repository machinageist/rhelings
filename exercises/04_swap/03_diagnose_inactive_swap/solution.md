```sh
swapon -a
# swapon: /swapfile-diag-old: stat failed: No such file or directory

ls -l /swapfile*
# only /swapfile-diag actually exists

sed -i 's#/swapfile-diag-old#/swapfile-diag#' /etc/fstab

swapon -a
swapon --show
```
