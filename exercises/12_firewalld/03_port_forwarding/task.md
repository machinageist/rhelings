# firewalld: port forwarding

A test app listens on TCP `8443`, but clients keep trying `8080` out of
habit. Rather than reconfigure every client, forward the traffic at the
firewall.

**Task:**

In the default zone, permanently forward local TCP port `8080` to `8443`,
reload, and confirm the forward rule is in the permanent config.

Both ports here are test ports for this exercise -- nothing about SSH is
involved.
