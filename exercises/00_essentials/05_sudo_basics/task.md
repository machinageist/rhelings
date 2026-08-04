# Essentials: sudo basics

The user `labtech` exists on this box but has no elevated access at all.
Ops wants `labtech` to be able to check the status of the `sshd` service
without ever being handed the root password.

**Task:**

Grant `labtech` passwordless `sudo` access to run exactly one command:
`/usr/bin/systemctl status sshd` -- nothing broader. Do it the safe way: a
dedicated drop-in file under `/etc/sudoers.d/`, not by editing `/etc/sudoers`
directly, and validated so a typo can't lock out sudo entirely.

Do not add `labtech` to the `wheel` group -- that would grant full root
access, which is a lot more than "check one service's status."
