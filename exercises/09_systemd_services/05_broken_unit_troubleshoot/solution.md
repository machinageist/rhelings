```sh
systemctl status rhelings-broken
journalctl -xeu rhelings-broken

# Fix ExecStart= in /etc/systemd/system/rhelings-broken.service to point at
# a real, executable binary, e.g.:
#   ExecStart=/usr/bin/sleep infinity

systemctl daemon-reload
systemctl restart rhelings-broken
systemctl status rhelings-broken
```
