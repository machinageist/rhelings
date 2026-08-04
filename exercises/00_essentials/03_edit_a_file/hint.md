`vi /root/rhelings-lab/motd-lab.txt`, then `dG` (delete from cursor to end of
file, after moving to the first line with `gg`) clears the old content before
you type the new lines. Or just delete every line manually with `dd`.

`nano /root/rhelings-lab/motd-lab.txt` lets you select and delete the old text
more like a normal editor -- select to end of file and delete, then type the
replacement.

Whichever editor you use, double-check there's no trailing blank line left at
the end -- `cat -A file` shows `$` at the end of each real line, which makes
stray blank lines obvious.
