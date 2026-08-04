# Essentials: editing a file with vi or nano

`/root/rhelings-lab/motd-lab.txt` already exists but has the wrong content.

**Task:**

Using a text editor (`vi`/`vim` or `nano` -- your choice, both are on the exam
machine), edit `/root/rhelings-lab/motd-lab.txt` so it contains **exactly**
these three lines, in this order, with no extra blank lines before, after, or
between them:

```
Authorized access only.
All activity is logged.
Contact: labadmin@example.com
```

If you've never used `vi` before: `i` enters insert mode so you can type,
`Esc` leaves insert mode, `:wq` saves and quits. `nano` is more like a
typical editor -- just type, then `Ctrl+O` to save and `Ctrl+X` to exit.
