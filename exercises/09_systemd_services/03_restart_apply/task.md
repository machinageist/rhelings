# systemd: applying a change with restart

Imagine a teammate just edited `rhelings-demo.service`'s configuration (in
reality nothing changed -- this drills the *workflow*, not a real config
diff). The running instance is still using whatever it started with.

**Task:**

Apply the change to the running service without a separate stop-then-start --
use the single command built for exactly that. Confirm with `systemctl
status` that the service is freshly active, not just still running from
before.
