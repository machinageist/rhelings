# Swap: diagnose swap that looks configured but isn't active

Someone on the previous shift says they "already set up swap" on this box.
`free -h` disagrees -- it shows zero swap. `/etc/fstab` does have a
swap-looking line in it already.

**Task:**

1. Figure out why the configured swap isn't actually active. Start by trying
   `swapon -a` and reading whatever it tells you -- don't just stare at the
   fstab line and guess.
2. Fix the actual problem (don't just delete the broken line and add a new
   unrelated one -- there's a real swap file already sitting on disk that the
   fix should end up using).
3. Confirm swap is active and will keep working with `swapon -a` (i.e. the
   fstab line itself is now correct, not just the current runtime state).
