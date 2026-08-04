```sh
firewall-cmd --permanent --add-forward-port=port=8080:proto=tcp:toport=8443
firewall-cmd --reload
firewall-cmd --permanent --list-forward-ports
```
