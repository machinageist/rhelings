`systemctl get-default` shows the current default target.

`systemctl set-default multi-user.target` changes it persistently -- under
the hood this just repoints the `/etc/systemd/system/default.target` symlink,
but let `systemctl` do it so you don't get the symlink target wrong.

Then actually reboot (`reboot` or `systemctl reboot`), log back in, and rerun
`rhelings` -- it resumes on this exercise automatically and the check key
will pick up from there.
