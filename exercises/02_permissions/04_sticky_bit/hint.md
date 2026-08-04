The sticky bit is the `1` in a 4-digit octal mode, or `+t` symbolically:

```sh
chmod +t /srv/scratch
# or, setting the full mode explicitly:
chmod 1777 /srv/scratch
```

`ls -ld /srv/scratch` shows a `t` in place of the final execute bit
(`rwxrwxrwt`) when it's set. `/tmp` on any Linux system is the classic
real-world example of this exact pattern.
