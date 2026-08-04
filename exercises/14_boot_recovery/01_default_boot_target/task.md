# Boot & Recovery: change the default boot target

This box is currently configured to boot into `graphical.target` by default
-- leftover from an image that was never meant to run headless. It should
boot into `multi-user.target` (full multi-user, network-enabled, no GUI)
instead, which is the right default for a server.

**Task:**

1. Persistently change the default boot target to `multi-user.target`, using
   the proper `systemctl` subcommand for this -- not by hand-editing the
   `/etc/systemd/system/default.target` symlink yourself.
2. **Reboot the machine.** This has to actually take effect across a real
   boot, not just look right in a config file -- `rhelings` will still be
   here when you log back in and re-launch it; it picks up exactly where you
   left off.
3. After logging back in, rerun `rhelings` and it will re-check this
   exercise automatically once you press the check key again.

This is a genuine reboot, done through your normal login/session -- nothing
about this exercise makes the system harder to get back into.
