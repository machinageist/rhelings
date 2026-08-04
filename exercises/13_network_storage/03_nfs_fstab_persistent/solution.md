```sh
echo "127.0.0.1:/srv/nfsshare  /mnt/nfsclient  nfs  defaults  0 0" >> /etc/fstab
mount /mnt/nfsclient
findmnt /mnt/nfsclient
```
