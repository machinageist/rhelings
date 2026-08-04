# DNF: transaction history and rollback

A teammate testing something on this box ran `dnf install -y nmap-ncat` by
mistake -- it was meant for a different machine. That install is the most
recent DNF transaction on this system.

**Task:**

1. Find that transaction in DNF's history.
2. Undo it, removing `nmap-ncat` the same way it was added -- via history, not
   a plain `dnf remove`.
3. Confirm `nmap-ncat` is gone.
