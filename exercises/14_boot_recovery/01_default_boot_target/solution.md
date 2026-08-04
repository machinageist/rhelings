```sh
systemctl get-default
systemctl set-default multi-user.target
reboot
```

After logging back in:

```sh
systemctl get-default   # multi-user.target
```
