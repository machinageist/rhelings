# Lab setup

`rhelings` changes real system state. This document is how to give it a system
whose state doesn't matter — written for someone who has never built a Linux VM
before. If you already run a homelab, skim the bold lines and skip the rest.

**The rule that makes everything else safe: the VM this runs on must be fully
disposable and fully isolated.** Not "I'll be careful." Disposable, meaning you
could `rm` it right now and lose nothing but time. Isolated, meaning it can't
reach anything on your real network even if an exercise misconfigures its
firewall or networking.

---

## 1. What you need

- A hypervisor. Any of these work; pick whichever you already have or find
  easiest to install:
  - **VirtualBox** (free, any OS, easiest on a laptop) — good default if you
    have no lab already.
  - **GNOME Boxes** or **virt-manager** (Linux, uses KVM/libvirt) — good
    default if you're on Linux.
  - **Proxmox** (a dedicated hypervisor host) — good if you already run one.
    If you're following along with a Proxmox-based homelab elsewhere, the
    same golden-template pattern in this doc is what to build there too.
- ~2 vCPUs, 2GB RAM, 20GB disk for the VM itself. `rhelings`' storage exercises
  create their own loopback-backed virtual disks inside the VM — you do not
  need to attach extra real disks.
- A **Rocky Linux 9** or **AlmaLinux 9** ISO ("minimal" install image is
  enough). Either is free and binary-compatible with RHEL, which is what the
  real exam environment resembles. Arch knowledge transfers conceptually but
  **not** command-for-command — build the VM on one of these, not Arch.

---

## 2. Build the VM — network isolation first

Before installing the OS, set the VM's network adapter to one of:

- **VirtualBox:** "NAT" or "Host-only Adapter" — not "Bridged."
- **virt-manager/GNOME Boxes:** the default NAT'd `virbr0` network — not a
  bridge to your physical interface.
- **Proxmox:** a dedicated lab VLAN/bridge with no route to your real LAN, or
  NAT through the host.

**Do not bridge this VM directly onto your home or work network.** Some
exercises intentionally misconfigure firewalld, SSH, or networking as the
thing you're meant to fix — isolation means a mistake there is a learning
moment, not an incident.

Install Rocky/Alma with the defaults: minimal install, one disk, a root
password you'll remember (or a user with `sudo`), SSH enabled. **Don't**
pre-configure SELinux, LVM, or anything else — a template that already has the
exam's hard parts solved is a template you can't practice on.

---

## 3. Snapshot immediately — this is your golden template

The moment the VM boots, you can log in, and `dnf update -y` has run once:
**take a snapshot** (VirtualBox: Machine → Take Snapshot; virt-manager: the
snapshot icon; Proxmox: Snapshots tab). Name it something like
`golden-minimal`.

This snapshot is the thing that makes the whole loop cheap. From here on:

1. Restore the snapshot (or clone the VM from it).
2. Do a rep — work through some `rhelings` exercises.
3. Throw the result away. Restore the snapshot again for the next rep.

You are never repairing a VM you broke. You're always starting from the same
known-clean state. That's what "throwaway scratch-VM rep loop" means in
practice — the golden template never accumulates exercise state; every session
starts identical.

---

## 4. Get `rhelings` onto the VM

Two ways to do this. Start with the first one — it's simpler and has fewer
moving parts, which matters more than speed for your first few reps.

### Simple: build it on the VM itself

The VM has internet access before you isolate it for a rep (or keep egress
open for updates/`dnf` — only inbound needs to stay closed). Install Rust
directly on the golden template, before taking the snapshot:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

Then get the `rhelings` source onto the VM (`git clone` if the VM can reach
GitHub, or `scp` the repo over from your workstation) and:

```sh
cargo build --release
sudo ./target/release/rhelings
```

Because you built it on the same machine you're running it on, there's no
cross-compilation and no glibc-version question to worry about. Take your
golden-template snapshot *after* this build succeeds, so every clone already
has a working `rhelings` binary sitting there.

### Faster repeats: cross-compile once, copy the binary

Once you're doing many reps and rebuilding the VM often, building on your own
workstation once and copying the binary in is faster than rebuilding Rust on
every clone. See the README's "Running → On the target VM" section for the
`x86_64-unknown-linux-musl` static-build steps — this avoids the glibc
mismatch between a newer build machine and an older RHEL-family target.

---

## 5. Run it

As root (almost every check needs root-only tools):

```sh
sudo ./rhelings
```

You'll see a warning banner every time you launch it — read it, it's not
boilerplate. Press Enter to continue into the exercise list.

If you're brand new to RHEL, work the domains in the order they appear in the
list — they're ordered as a learning path, not alphabetically. `00_essentials`
assumes nothing; later domains assume you've done the earlier ones.

Keybindings are in the README. The short version: `c` to check your work,
`h` for a hint if you're stuck, `r` to reset an exercise and try it again from
a clean broken state, `n` to move on once you've passed.

---

## 6. Between sessions

When you're done for the day, or when you want a clean slate: restore the
golden-template snapshot. Don't try to manually undo what an exercise did —
that's slower than restoring and defeats the point of the loop. Progress is
tracked in `.rhelings-state.txt` next to the binary; if you restored a
snapshot taken *after* your last session, that file (and your exercise
progress) comes back with it. If you restored the original golden template,
progress resets too — which is fine, reps are supposed to be repeatable.

---

## 7. What not to do

- Don't run `rhelings` on your workstation, a shared machine, or any VM you
  use for something else. The warning banner says this every time for a
  reason.
- Don't bridge the lab VM onto a real network.
- Don't treat this as your evidence/portfolio system. This tool is the fast
  "can I do it under pressure" loop, not the slow "build something worth
  writing up" loop — those are deliberately different systems for a reason:
  conflating them is how people build an impressive homelab and still fail a
  timed performance exam.
