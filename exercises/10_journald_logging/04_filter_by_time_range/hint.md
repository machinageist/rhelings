`--since` and `--until` both accept `"YYYY-MM-DD HH:MM:SS"` timestamps
directly, or relative expressions like `"-10 minutes"`. Read the two values
out of `/root/rhelings-10-04-window.txt` and pass them straight through:
`journalctl -t rhelings-window --since "<since>" --until "<until>"`.
