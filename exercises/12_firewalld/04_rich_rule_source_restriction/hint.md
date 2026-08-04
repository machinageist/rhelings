Rich rules go in as one quoted string:

```sh
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.0.2.0/24" port port="9000" protocol="tcp" accept'
```

Then `--reload`, then `firewall-cmd --permanent --list-rich-rules` to
confirm.
