`dnf history list nmap-ncat` (or just `dnf history list` and look near the
top) shows the transaction ID. `dnf history undo <id>` reverses that exact
transaction. If it really is the most recent one, `dnf history undo last`
works too.
