# journald: filtering by priority

A batch job logged several messages under the syslog identifier
`rhelings-batch`, at a mix of priorities. Exactly one of them was logged at
priority `err`.

**Task:**

Use `journalctl` filtered by both unit/identifier and priority to find that
one `err`-priority message, then write its exact text (nothing else) to
`/root/rhelings-10-02-answer.txt`.
