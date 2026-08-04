# Permissions: standard rwx bits (chmod)

`/root/rhelings-lab/secrets/` holds a couple of files with the wrong
permissions -- currently wide open, which is not what you want for anything
resembling credentials.

**Task:**

Set these exact permissions:

1. The directory `/root/rhelings-lab/secrets/` itself: `750`
   (owner rwx, group rx, others nothing).
2. `/root/rhelings-lab/secrets/db.env`: `640`
   (owner rw, group r, others nothing).
3. `/root/rhelings-lab/secrets/rotate.sh`: `750`
   (owner rwx, group rx, others nothing -- it's a script, the owner and group
   need to be able to execute it).

Use exact octal modes, not `chmod +x` / `chmod -w` style adjustments -- the
task specifies the final permission bits precisely.
