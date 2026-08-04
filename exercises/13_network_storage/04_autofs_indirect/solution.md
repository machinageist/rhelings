```sh
cat > /etc/auto.master.d/rhelings.autofs <<'EOF'
/mnt/auto  /etc/auto.rhelings
EOF

cat > /etc/auto.rhelings <<'EOF'
nfsshare  -ro,soft  127.0.0.1:/srv/nfsshare
EOF

systemctl enable --now autofs
systemctl restart autofs

ls /mnt/auto/nfsshare
mount | grep nfsshare
```
