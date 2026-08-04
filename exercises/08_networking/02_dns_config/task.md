# Networking: DNS servers on a connection profile

**Safety note:** this exercise runs against `dummy1`, a throwaway interface
created just for this drill -- your real management interface and its DNS
settings are untouched.

There's already a manual/static connection profile on `dummy1`, but it has no
DNS servers configured.

**Task:**

Add DNS servers `198.51.100.1` and `198.51.100.2` (TEST-NET-2 -- reserved for
documentation, safe to use here) to that profile, then confirm they're saved.
