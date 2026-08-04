Extract: `tar -xzf bundle.tar.gz -C /root/rhelings-lab/` (x = extract,
z = gzip, f = filename; `-C` changes to that directory first so you don't end
up extracting into your current working directory by accident).

Create the new file with `echo "done" > .../summary.txt` or an editor.

Re-archive: `tar -czf bundle-updated.tar.gz -C /root/rhelings-lab bundle`
(c = create). Running it from `/root/rhelings-lab` with `-C` first means the
archive's paths start with `bundle/...` instead of a long absolute path.

Check what's inside any tarball without extracting it: `tar -tzf file.tar.gz`.
