# Users & Groups: delete a user with home-directory cleanup

`tmpcontractor` was a short-term contractor account. Their contract ended,
there's no data-retention requirement for this one, and the account (including
its home directory and mail spool) needs to be gone completely -- not just
disabled.

**Task:**

Delete the user `tmpcontractor`, including their home directory.

(Contrast with just removing an account but *keeping* the home directory for
an employee whose data still needs to be archived -- that's a different flag.
This task is the "delete everything" case.)
