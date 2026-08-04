`nmcli connection up dummy2-static` activates the profile. `ip -4 addr show
dev dummy2` (or `nmcli device show dummy2`) shows what's actually applied to
the live interface, as opposed to what's merely saved in the profile.
