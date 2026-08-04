# DNF: adding and enabling a repository

A vendor dropped a small internal package repository on this box at
`/opt/vendor-repo` (already built and populated by IT -- you don't need to run
`createrepo` yourself). DNF doesn't know about it yet.

**Task:**

1. Add a `.repo` file under `/etc/yum.repos.d/` that defines this repository:
   repo id `vendor`, pointing at `file:///opt/vendor-repo`, enabled.
2. Confirm DNF sees it as an enabled repository.

This is an internal, unsigned mirror -- for this repo only, GPG checking
should be off (`gpgcheck=0`). That's not a general recommendation, just what
this particular internal mirror calls for.
