```sh
cat > /root/.rhelings-13-05-credentials <<'EOF'
username=rhelings-smb
password=rhelings-smb-pass123
EOF
chmod 600 /root/.rhelings-13-05-credentials

mount -t cifs //127.0.0.1/rhelingsshare /mnt/smbclient \
    -o credentials=/root/.rhelings-13-05-credentials

findmnt /mnt/smbclient
ls /mnt/smbclient
```
