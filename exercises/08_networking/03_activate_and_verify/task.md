# Networking: activating a profile and verifying it live

**Safety note:** this exercise runs against `dummy2`, a throwaway interface --
it is not your management NIC and bringing it up/down cannot drop your
session.

A static connection profile exists for `dummy2` but has never been activated.
Configuration on disk isn't the same thing as configuration that's live.

**Task:**

1. Bring the `dummy2-static` profile up.
2. Confirm the address is actually applied to the interface (not just saved
   in the profile) by inspecting the live interface state.
