# firewalld: binding a zone by source

Traffic from the `203.0.113.0/24` range (TEST-NET-3, reserved for
documentation) should be treated as internal rather than falling under the
default zone's rules. firewalld can bind a zone to a source network directly
-- no interface reassignment required.

**Task:**

Permanently add `203.0.113.0/24` as a source for the `internal` zone. Reload
and confirm it's there.

This binds a zone to a *source network*, not to any interface -- it has no
effect on your real network interface or on SSH.
