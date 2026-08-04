`grep PATTERN file` prints matching lines to your terminal (stdout).

`>` redirects stdout to a file instead of the terminal, overwriting it:

```sh
grep ERROR /root/rhelings-lab/app.log > /root/rhelings-lab/errors.txt
```

Use `>` (create/overwrite), not `>>` (append) -- you want exactly the ERROR
lines, not those lines added onto whatever might already be in errors.txt.
