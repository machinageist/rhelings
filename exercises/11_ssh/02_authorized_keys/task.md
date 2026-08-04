# SSH: installing an authorized key

A teammate sent over their public key so they can log in as the local test
account `rhelings-alice`. It's staged at
`/root/rhelings-11-02-staged/teammate_key.pub`.

**Task:**

Install that public key as an authorized key for `rhelings-alice`, with
correct ownership and permissions on `~rhelings-alice/.ssh` and
`authorized_keys` (`sshd` silently ignores authorized keys with wrong
permissions -- this isn't optional).

This exercise only wires up the file. It does not test an actual SSH login --
nothing here can affect your current session.
