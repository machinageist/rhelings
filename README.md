# rhelings

A [rustlings](https://github.com/rust-lang/rustlings)-style drill loop for RHCSA
(Red Hat Certified System Administrator, exam EX200) prep -- except instead of
fixing broken Rust code, each exercise is a real sysadmin task checked by
inspecting live system state.

---

## ⚠️ Warning: this tool changes real system state

There is no sandbox and nothing here is simulated. Every exercise runs actual
commands against the actual machine `rhelings` is launched on: SELinux modes and
contexts today, and in later milestones LVM volumes, firewalld rules, users, and
boot configuration.

**Run this only on a disposable VM you can destroy and rebuild.** Never on a
workstation, a shared box, or anything you'd be upset to lose. Run it as root --
almost every check needs root-only tools (`semanage`, `restorecon`, `setsebool`).

A loud version of this warning is shown on every launch and requires pressing
Enter to continue. That prompt is the only safety mechanism this tool has.

---

## Overview

Exam prep for a live, performance-based exam ("do these tasks on a real system
in 2.5 hours") doesn't fit a multiple-choice quiz format. It also doesn't fit a
slow, carefully-documented homelab build -- that teaches you to work carefully,
not fast. `rhelings` is the fast, throwaway rep loop: clone a disposable
RHEL-family VM, run `rhelings`, work through exercises, destroy the VM, repeat.

Each exercise is a directory containing a task prompt, an optional setup script
that arranges the starting (broken) state, a check script that inspects the
real system to decide pass/fail, an on-demand hint, and a reference solution.
The whole `exercises/` tree is embedded into the compiled binary, so a single
release build can be copied onto a scratch VM without needing git or this repo
present there.

**Current scope: SELinux only** -- the domain most commonly under-covered
before RHCSA prep starts (enforcing/permissive, persistent config, `restorecon`,
`semanage fcontext`, `semanage port`, booleans, and diagnosing an AVC denial).
LVM, podman/containers, boot-level recovery, and the rest of the EX200 objective
list are planned follow-ups, not yet implemented.

---

## Tech Stack

| Component | Purpose |
|---|---|
| **crossterm** | Terminal UI (raw mode, alternate screen) -- no TUI framework, hand-rolled |
| **include_dir** | Embeds `exercises/` into the compiled binary at build time |
| **toml** / **serde** | Parses the exercise manifest |
| **clap** | Command-line argument parsing |
| **anyhow** | Error handling |

---

## Project Structure

```text
rhelings/
├── Cargo.toml
├── LICENSE                      # MIT, forked from rustlings -- see file for attribution
├── exercises/
│   ├── exercises.toml            # manifest: name, dir, domain, kind per exercise
│   └── 01_selinux/
│       └── 01_enforcing_permissive/
│           ├── task.md           # the prompt, shown in the TUI
│           ├── setup.sh          # optional: arranges the starting broken state
│           ├── check.sh          # exit 0 = pass; stdout/stderr shown as diagnostic
│           ├── hint.md           # optional, on-demand
│           └── solution.md       # reference commands, shown only after a pass
└── src/
    ├── main.rs                   # banner, manifest load, dispatch
    ├── banner.rs                 # the startup warning -- see above
    ├── manifest.rs                # exercises.toml -> ExerciseInfo
    ├── embedded.rs                # include_dir lookup for task.md/check.sh/etc.
    ├── exercise.rs                 # runs an exercise's setup.sh/check.sh
    ├── cmd.rs                     # bash -c runner, captures output + exit status
    ├── app_state.rs                # progress tracking, persisted to .rhelings-state.txt
    ├── term.rs                    # shared terminal-rendering primitives
    ├── list.rs / list/            # exercise list screen (nav, search, filter)
    └── run.rs / run/              # the default screen: current exercise + actions
```

---

## Running

### On the target VM (the intended way)

Build a static release binary and copy it to a disposable Rocky/Alma/RHEL VM:

```sh
rustup target add x86_64-unknown-linux-musl
# Arch doesn't ship musl-gcc by default:
sudo pacman -S musl
cargo build --release --target x86_64-unknown-linux-musl
scp target/x86_64-unknown-linux-musl/release/rhelings root@your-scratch-vm:/root/
```

If native musl linking fails, [`cargo-zigbuild`](https://github.com/rust-cross/cargo-zigbuild)
is a documented fallback (`cargo zigbuild --release --target x86_64-unknown-linux-musl`).

Static linking avoids glibc version mismatches between a rolling-release build
machine and an older RHEL-family target -- a dynamically-linked binary built
against a newer glibc may refuse to run against an older one.

On the VM, as root:

```sh
./rhelings
```

Some exercises need `semanage`/`restorecon`/`matchpathcon`, which live in
`policycoreutils-python-utils` and aren't always present on a minimal install:

```sh
dnf install -y policycoreutils-python-utils
```

### Locally, for development

```sh
cargo run
```

Runs fine on any Linux box for navigating the UI and editing exercise content,
but the SELinux exercises' `check.sh`/`setup.sh` scripts assume RHEL-family
tooling and will simply fail (not misbehave) on a non-RHEL system like Arch.

```sh
cargo test    # manifest parsing, state-file format, embedded-file lookups --
              # none of these execute any exercise's check.sh/setup.sh
```

### Keybindings

Run screen: `c` check &middot; `h` hint &middot; `s` solution (after a pass)
&middot; `r` reset (rerun setup.sh) &middot; `n` next (after a pass) &middot;
`l` exercise list &middot; `q` quit.

List screen: `j`/`k`/arrows navigate &middot; `g`/`G` first/last &middot; `d`/`p`
filter done/pending &middot; `s` or `/` search &middot; `c`/Enter jump to
selected &middot; `q` back.

---

## Security

This is a fork of [rustlings](https://github.com/rust-lang/rustlings) (MIT), with
its exercise-checking engine replaced end to end -- see `LICENSE` for the
preserved original copyright. There's no network access, no credential
handling, and no data collection; the only thing it does is run local shell
scripts as whatever user launched it. Treat its trust boundary as identical to
running any shell script you wrote yourself: only run exercise content you've
read, and only on a system you're prepared to have changed.
