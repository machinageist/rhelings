# Swap: create swap as a file

This box has no swap configured. Add some the simplest way: a regular file
used as swap space rather than a dedicated partition.

**Task:**

1. Create a swap file at `/swapfile-lab` of exactly **256MB**.
2. Set its permissions so only root can read or write it (`600`) -- a
   world-readable swap file is a real information-disclosure risk, since
   whatever's in RAM (including things like passwords) can end up written to
   swap.
3. Initialize it as swap space and activate it.
4. Make it activate automatically on every boot, via `/etc/fstab`, not just
   for the current session.
