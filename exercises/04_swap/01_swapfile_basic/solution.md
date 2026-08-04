```sh
dd if=/dev/zero of=/swapfile-lab bs=1M count=256
chmod 600 /swapfile-lab
mkswap /swapfile-lab
swapon /swapfile-lab

echo "/swapfile-lab  none  swap  sw  0  0" >> /etc/fstab

swapon --show
free -h
```
