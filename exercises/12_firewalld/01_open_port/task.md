# firewalld: opening a port

A test app on this box needs to accept connections on TCP port `8443`.
Nothing is open for it right now.

**Task:**

Permanently open TCP port `8443` in the default zone, then reload so the
running configuration matches. Confirm it's actually there in the permanent
config afterward.

This does not touch SSH or its port -- only 8443.
