# journald: filtering by time range

Three events were logged under the syslog identifier `rhelings-window`: one
before a window, one inside it, and one after it. The window's exact
boundaries (`since` and `until` timestamps) are recorded in
`/root/rhelings-10-04-window.txt`.

**Task:**

Using `journalctl -t rhelings-window --since "<since>" --until "<until>"`
with the values from that file, confirm exactly one event falls inside the
window, then write its exact text (nothing else) to
`/root/rhelings-10-04-answer.txt`.
