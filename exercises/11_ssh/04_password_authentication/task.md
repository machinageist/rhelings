# SSH: disabling password authentication

Key-based auth is set up for the accounts that need it. Password
authentication is still allowed on top of that, which undermines the whole
point.

**Task:**

Edit `/etc/ssh/sshd_config` so password authentication is disabled
(`PasswordAuthentication no`), leaving key-based auth as the only way in.

**Do not restart or reload `sshd`.** This exercise only checks the config
file's syntax and effective values -- it never touches the running SSH
daemon. This is exactly the kind of change that locks people out when
applied carelessly: before you'd ever reload `sshd` for real with this
setting, open a **second** session and confirm key-based login actually
works for an account that needs it. If it doesn't, you'll find out from the
second session, not by losing the first.
