# Essentials: tar and gzip

`/root/rhelings-lab/bundle.tar.gz` is a compressed archive containing a small
directory tree.

**Task:**

1. Extract `/root/rhelings-lab/bundle.tar.gz` into `/root/rhelings-lab/`, so it
   produces a `bundle/` directory there containing its original contents
   (`bundle/notes.txt` and `bundle/data/values.csv`).
2. Add a new file `bundle/data/summary.txt` containing the single line
   `done` (no extra whitespace, no extra lines).
3. Re-archive the entire `bundle/` directory as a new gzip-compressed tarball
   at `/root/rhelings-lab/bundle-updated.tar.gz`, so it contains all four
   files: the two originals plus the new `summary.txt`.

This is the two directions you'll use constantly: unpacking something you were
handed, and packaging something up to hand off or back up.
