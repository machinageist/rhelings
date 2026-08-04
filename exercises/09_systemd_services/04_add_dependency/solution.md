```sh
# Add to the [Unit] section of /etc/systemd/system/rhelings-demo.service:
#   After=network-online.target
#   Wants=network-online.target

systemctl daemon-reload
systemctl restart rhelings-demo
systemctl list-dependencies rhelings-demo
```
