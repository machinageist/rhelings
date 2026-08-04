```sh
echo "SystemMaxUse=50M" >> /etc/systemd/journald.conf
systemctl restart systemd-journald
grep '^SystemMaxUse=' /etc/systemd/journald.conf
```
