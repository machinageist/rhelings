# SSH: generating a keypair

`rhelings-alice` is a local test account on this box. She needs an SSH
keypair of her own before key-based auth can be set up for her (that's the
next exercise).

**Task:**

Generate an `ed25519` SSH keypair for `rhelings-alice`, saved at her
account's default key location, with no passphrase (fine here -- this is
lab automation, never do this for a real account without either a passphrase
or a proper secrets broker).

This exercise only generates the key. It does not touch `sshd_config` and
does not test any actual login -- nothing here can affect your current
session.
