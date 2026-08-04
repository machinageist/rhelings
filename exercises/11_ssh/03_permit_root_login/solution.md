```sh
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sshd -t
sshd -T | grep -i permitrootlogin
```

Not reloaded here on purpose. To apply for real: open a second session,
confirm non-root login still works, then `systemctl reload sshd` from the
first.
