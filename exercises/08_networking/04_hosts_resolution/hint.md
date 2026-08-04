Static hostname resolution lives in `/etc/hosts` -- add a line like
`192.0.2.50  app-db.internal`. `getent hosts app-db.internal` confirms it
resolves through the actual resolver path, not just that the line exists.
