# Permissions: ownership (chown/chgrp)

A deploy script dropped `/root/rhelings-lab/deploy/` on this box owned by
`root:root` everywhere. It should actually belong to the `appsvc` user and
the `appteam` group, all the way down the tree -- the app runs as `appsvc`
and needs to write into it.

**Task:**

Recursively change the owner of everything under `/root/rhelings-lab/deploy/`
to user `appsvc` and group `appteam`.
