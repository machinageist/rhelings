# firewalld: a rich rule

A custom app listens on TCP `9000`. It should only be reachable from the
`192.0.2.0/24` range (TEST-NET-1, reserved for documentation -- safe to use
here) -- everyone else should be rejected. A plain `--add-port` can't express
a source restriction; that needs a rich rule.

**Task:**

Add a permanent rich rule to the default zone: accept TCP port `9000` from
`192.0.2.0/24`. Reload and confirm it's in the permanent config.

This only concerns port 9000 -- it does not touch SSH or its port.
