# firewalld: opening a predefined service

firewalld ships predefined service definitions (bundles of ports/protocols
under a friendly name) so you don't have to remember raw port numbers for
common daemons. The `http` service definition is not currently allowed
through the default zone.

**Task:**

Permanently add the `http` service to the default zone, reload, and confirm
it's there.

This is about the `http` service definition only -- it does not touch `ssh`.
