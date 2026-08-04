# Users & Groups: create a user with a specific UID

A new hire needs an account. Because their old account on a decommissioned box
had UID `5010` and some files owned by that UID are being migrated over via
NFS, the new account needs to **reuse that exact UID** so ownership carries
over.

**Task:**

Create a user named `jsmith` with UID `5010` and a standard home directory
(`/home/jsmith`, created automatically).
