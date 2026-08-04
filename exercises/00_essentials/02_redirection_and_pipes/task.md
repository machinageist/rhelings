# Essentials: redirection and pipes

`/root/rhelings-lab/app.log` is a small application log. Some lines are normal,
some are errors.

**Task:**

Using `grep` and output redirection (not a text editor), create
`/root/rhelings-lab/errors.txt` containing **only** the lines from `app.log`
that contain the word `ERROR`, in the same order they appear in the original
file.

This is the pattern (search, then redirect the result to a new file) you'll use
constantly for real troubleshooting -- pulling the interesting lines out of a
much bigger log instead of reading the whole thing.
