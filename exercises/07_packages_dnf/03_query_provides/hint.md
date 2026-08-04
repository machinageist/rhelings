`dnf provides '*/killall'` (or `dnf provides */bin/killall`) tells you which
package owns that file without installing anything yet. Once you know the
name, `dnf install -y <package>` installs it.
