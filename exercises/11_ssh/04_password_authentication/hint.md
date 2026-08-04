Set `PasswordAuthentication no` in `/etc/ssh/sshd_config`. `sshd -t` checks
syntax only. `sshd -T | grep -i passwordauthentication` shows the effective,
fully-resolved value (accounting for any `/etc/ssh/sshd_config.d/*.conf`
drop-ins), which is more reliable than grepping the main file directly.
