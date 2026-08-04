`usermod -G opsteam dbryant` (without `-a`) **replaces** the entire secondary
group list with just `opsteam` -- that's how you'd accidentally kick someone
out of every other group they're in.

`usermod -aG opsteam dbryant` (`-a` = append) adds `opsteam` to whatever
secondary groups they already have, leaving the rest alone.

`gpasswd -a dbryant opsteam` does the same thing and is arguably more obviously
named -- either is correct on the exam.
