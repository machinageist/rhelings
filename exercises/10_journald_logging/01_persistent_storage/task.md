# journald: persistent storage

By default on a fresh install, the journal only lives in `/run` -- volatile
memory that's wiped on every reboot. That's fine for a quick debug session,
not fine for a box you actually want log history from.

**Task:**

Configure journald to store the journal persistently on disk (surviving
reboots), and apply the change without actually rebooting.
