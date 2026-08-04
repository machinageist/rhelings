```sh
firewall-cmd --permanent --zone=internal --add-source=203.0.113.0/24
firewall-cmd --reload
firewall-cmd --permanent --zone=internal --list-sources
```
