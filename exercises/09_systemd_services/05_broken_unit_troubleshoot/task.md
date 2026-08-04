# systemd: troubleshooting a broken unit

`rhelings-broken.service` refuses to start. Someone hand-edited its unit file
and got something wrong.

**Task:**

1. Diagnose why it's failing. Start with `systemctl status rhelings-broken`
   and `journalctl -xeu rhelings-broken` -- read the actual error, don't
   guess.
2. Fix the real problem in `/etc/systemd/system/rhelings-broken.service`
   (don't mask it, don't work around it with a different unit).
3. Reload systemd and get the service running.

This is the single most common way a systemd unit fails in the real world: a
bad `ExecStart=` path that doesn't exist, producing a `203/EXEC` failure.
