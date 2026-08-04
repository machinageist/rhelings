# systemd: enabling and starting a service

`rhelings-demo.service` is a small long-running unit installed on this box
for these exercises (it just runs `sleep infinity` -- there's nothing real
behind it, it's a stand-in for "some daemon"). Right now it's stopped and
disabled.

**Task:**

Get `rhelings-demo.service` running right now, AND make sure it starts
automatically on future boots. Those are two separate things -- one command
each.
