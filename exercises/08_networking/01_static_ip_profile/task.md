# Networking: a static IPv4 connection profile

**Safety note:** this exercise never touches your real management interface.
`setup.sh` creates a throwaway `dummy0` interface just for this drill --
nothing here can drop your session.

A test service needs a fixed address on a dummy interface (`dummy0`, already
present on this box) instead of picking one up dynamically.

**Task:**

Create a new NetworkManager connection profile bound to `dummy0` with:

- a static (manual) IPv4 method
- address `192.0.2.10/24` (this is TEST-NET-1, reserved for documentation --
  safe to use here, never routable on a real network)

Give the profile whatever name makes sense to you. You don't need to bring it
up yet -- that's the next exercise.
