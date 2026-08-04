```sh
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sshd -t
sshd -T | grep -i passwordauthentication
```

Not reloaded here on purpose. To apply for real: from a **second** session,
confirm key-based login works for an account that needs access, then
`systemctl reload sshd` from the first.
