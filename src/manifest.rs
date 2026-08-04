// Author:      Jeff
// Date:        2026-08-03
// Description: Parses exercises/exercises.toml, embedded at compile time, into the
//              list of exercises rhelings knows about.
// Notes:       Unlike upstream rustlings, this doesn't need a proc-macro crate --
//              exercises are markdown + bash, not Rust source to be embedded as
//              compiled code, so a plain include_str! + toml::from_str is enough.

use anyhow::{Context, Result};
use serde::Deserialize;

const MANIFEST_TOML: &str = include_str!("../exercises/exercises.toml");

#[derive(Deserialize)]
pub struct Manifest {
    pub welcome_message: String,
    pub final_message: String,
    pub exercises: Vec<ExerciseInfo>,
}

#[derive(Deserialize, Clone)]
pub struct ExerciseInfo {
    pub name: String,
    pub dir: String,
    pub domain: String,
    #[serde(default)]
    pub kind: ExerciseKind,
    // Reserved for a future v2 auto-recheck-on-save feature (e.g. re-running
    // check.sh when /etc/fstab changes). Deliberately unused in v1 -- kept on
    // the struct now so a v2 manifest doesn't need a migration to add it.
    #[serde(default)]
    #[allow(dead_code)]
    pub watch_file: Option<String>,
}

#[derive(Deserialize, Clone, Copy, PartialEq, Eq, Default)]
#[serde(rename_all = "snake_case")]
pub enum ExerciseKind {
    #[default]
    Standard,
    Reboot,
}

// Parse the embedded exercises.toml into a Manifest
pub fn parse() -> Result<Manifest> {
    toml::from_str(MANIFEST_TOML).context("Failed to parse exercises/exercises.toml")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_embedded_manifest() {
        let manifest = parse().expect("embedded exercises.toml must parse");
        assert!(!manifest.exercises.is_empty());

        for exercise in &manifest.exercises {
            assert!(!exercise.name.is_empty());
            assert!(!exercise.dir.is_empty());
            assert!(!exercise.domain.is_empty());
        }
    }
}
