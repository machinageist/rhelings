# Networking: static hostname resolution

A small internal tool on this box needs to reach `app-db.internal`, a host
that has no real DNS record -- it only exists on paper as `192.0.2.50` (a
TEST-NET-1 documentation address).

**Task:**

Add a static hostname resolution entry so this box resolves `app-db.internal`
to `192.0.2.50`, without touching any DNS server. Confirm resolution actually
works via the standard resolver, not just by reading the file back.
