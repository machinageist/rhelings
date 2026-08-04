```sh
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.0.2.0/24" port port="9000" protocol="tcp" accept'
firewall-cmd --reload
firewall-cmd --permanent --list-rich-rules
```
