`firewall-cmd --permanent --zone=internal --add-source=203.0.113.0/24` binds
the network to the zone directly by source address -- traffic from that
range gets the `internal` zone's rules regardless of which interface it
arrives on. `--reload` applies it; `--list-sources` confirms it.
