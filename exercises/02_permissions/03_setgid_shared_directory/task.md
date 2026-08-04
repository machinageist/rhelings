# Permissions: setgid on a shared collaboration directory

`/srv/projects/launch/` is a shared workspace for the `launch` team. Everyone
on the team is in the `launchteam` group. Right now, when different team
members create files in there, each new file ends up owned by *that person's*
primary group -- not `launchteam` -- so people keep having to `chgrp` things
by hand after the fact.

**Task:**

1. Set the directory's group ownership to `launchteam`.
2. Set the **setgid bit** on the directory, so any new file or subdirectory
   created inside it automatically inherits the `launchteam` group, no matter
   which user creates it.

Verify by creating a test file inside the directory as root and confirming its
group is `launchteam` without you having to `chgrp` it manually.
