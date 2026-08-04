# SSH: disabling root login

Direct root logins over SSH are still allowed on this box -- every real
audit will flag that.

**Task:**

Edit `/etc/ssh/sshd_config` so root cannot log in over SSH at all
(`PermitRootLogin no`).

**Do not restart or reload `sshd`.** This exercise only checks the config
file's syntax and effective values -- it never touches the running SSH
daemon, so there's no risk to your current session either way. If you want
to apply this for real later, open a **second** session first and confirm
you can still get in as a non-root user before you reload `sshd` in the
first one.
