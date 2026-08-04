# Networking: setting the static hostname

This box was imaged from a template and never got its real hostname set --
it's still sitting at the generic default.

**Task:**

Set this system's static hostname to `rhcsa-lab.example.com`, persistently
(it needs to survive a reboot, not just show up in the current shell prompt).

This only changes how the machine identifies itself. It doesn't touch any
network interface or connection, and it can't affect your ability to stay
connected to this session.
