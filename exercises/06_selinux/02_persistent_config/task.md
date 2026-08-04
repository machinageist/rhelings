# SELinux: the persistent (boot-time) setting

Someone set the box up with SELinux permissive at boot -- fine for imaging, not
fine for anything that ships. The *runtime* mode might look fine right now, but
that's not what matters here.

**Task:**

Edit the config file that controls what mode SELinux boots into, so this box
comes up **enforcing** on its next boot. Don't just fix the runtime mode with
`setenforce` -- that doesn't persist.
