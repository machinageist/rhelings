# SELinux: enforcing vs. permissive

A colleague was debugging something on this box and left SELinux in
**Permissive** mode. Permissive logs denials but doesn't block anything -- fine
for debugging, not fine to leave running.

**Task:**

1. Confirm the current runtime mode.
2. Set it back to **Enforcing** without rebooting.
3. Confirm the change took effect.

This only changes the *runtime* mode. It does not touch any config file, and it
will not survive a reboot -- that's the next exercise.
