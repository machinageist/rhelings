# Users & Groups: create a group with a specific GID

The `webteam` project needs a shared group. Files owned by this group already
exist on a fileserver being migrated in, labeled with GID `6001` -- the new
group has to reuse that exact GID or ownership on the migrated files will
resolve to the wrong group (or no group at all).

**Task:**

Create a group named `webteam` with GID `6001`.
