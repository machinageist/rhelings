# Swap: swap priority

Two swap files already exist and are both active: `/swapfile-fast` (backed by
what's meant to represent a fast SSD-like device) and `/swapfile-slow`
(meant to represent slower storage). Right now the kernel treats them as
equal priority and will interleave writes across both -- not what you want
when one is genuinely faster than the other.

**Task:**

Reconfigure both, **persistently** (via `/etc/fstab`, not just for the
current boot), so that:

- `/swapfile-fast` has priority `10`
- `/swapfile-slow` has priority `5`

Higher priority swap is preferred by the kernel first, so this makes sure the
faster device gets used before the kernel falls back to the slower one.
