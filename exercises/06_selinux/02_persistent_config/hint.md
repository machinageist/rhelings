The runtime mode (`getenforce`/`setenforce`) and the boot-time default are two
different things. The persistent setting lives in `/etc/selinux/config`, in a
line that looks like `SELINUX=enforcing` (or `permissive` or `disabled`). Edit it
directly, e.g. with `vi` or `sed`.
