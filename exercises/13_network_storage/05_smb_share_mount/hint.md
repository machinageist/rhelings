```
# /root/.rhelings-13-05-credentials
username=rhelings-smb
password=rhelings-smb-pass123
```

`chmod 600` that file -- `mount.cifs` will actually warn you if it's more
open than that. Then:

```sh
mount -t cifs //127.0.0.1/rhelingsshare /mnt/smbclient \
    -o credentials=/root/.rhelings-13-05-credentials
```

A credentials file avoids putting a password directly on the command line
(and therefore in shell history and `ps` output).
