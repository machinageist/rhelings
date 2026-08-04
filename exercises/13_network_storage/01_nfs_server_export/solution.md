```sh
echo "/srv/nfsshare  127.0.0.1(ro,sync)" >> /etc/exports
systemctl enable --now nfs-server
exportfs -ra
exportfs -v
```
