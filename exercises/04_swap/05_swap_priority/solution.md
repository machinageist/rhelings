```sh
sed -i 's#^/swapfile-fast.*#/swapfile-fast  none  swap  sw,pri=10  0  0#' /etc/fstab
sed -i 's#^/swapfile-slow.*#/swapfile-slow  none  swap  sw,pri=5   0  0#' /etc/fstab

swapoff /swapfile-fast /swapfile-slow
swapon -a

swapon --show
```
