# Boot & Recovery: fix a boot failure caused by a bad fstab entry

A bad `/etc/fstab` entry has been added to this box -- it references a
filesystem that doesn't exist. Right now the system is still running fine
(nothing gets re-evaluated until the next boot), but on the *next* boot,
systemd will try to mount everything in `/etc/fstab` and this entry will
fail, dropping the system into **emergency mode** instead of reaching normal
multi-user operation.

**Task:**

1. **Reboot the machine now**, before touching anything -- you need to
   actually see the failure this task is about, not just take it on faith.
2. You'll land in an emergency shell (systemd will prompt for the **root
   password** to get there -- that's expected, not a bug). The root
   filesystem is typically mounted **read-only** in this mode; you'll need to
   remount it read-write before you can edit anything.
3. Find and fix the bad line in `/etc/fstab`. The safe fix here is to
   **remove the bad entry** -- there's no real filesystem behind it to
   correct the line to point at.
4. Reboot again and confirm the system now reaches normal operation
   (`multi-user.target` or `graphical.target`, not emergency or rescue).
5. Log back in, rerun `rhelings`, and press the check key -- it resumes here
   automatically.

This is one of the most common real RHCSA recovery scenarios: one bad line in
`/etc/fstab` can take a whole boot down, and knowing how to get back in and
fix it without a live/rescue ISO is a core exam skill.
