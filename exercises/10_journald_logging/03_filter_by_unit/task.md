# journald: filtering by unit

A small one-shot unit, `rhelings-logtest.service`, ran once on this box and
logged a single message.

**Task:**

Use `journalctl` filtered by that unit (`-u`) to find the message it logged,
then write its exact text (nothing else) to
`/root/rhelings-10-03-answer.txt`.
