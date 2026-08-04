// Author:      Jeff
// Date:        2026-08-03
// Description: Embeds the exercises/ directory tree into the compiled binary, so a
//              single release build is portable to a disposable VM without needing
//              git or the repo present there.
// Notes:       Lookups read straight from the in-memory Dir -- nothing is ever
//              written to disk. A missing optional file (e.g. no setup.sh) is a
//              normal, expected case, not an error.

use include_dir::{Dir, include_dir};

static EXERCISES_DIR: Dir = include_dir!("$CARGO_MANIFEST_DIR/exercises");

// Read a named file inside one exercise's directory, if it exists
pub fn read_exercise_file(dir: &str, name: &str, file: &str) -> Option<&'static str> {
    let path = format!("{dir}/{name}/{file}");
    EXERCISES_DIR.get_file(&path)?.contents_utf8()
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::manifest;

    #[test]
    fn every_exercise_has_task_and_check() {
        let manifest = manifest::parse().expect("embedded exercises.toml must parse");

        for exercise in &manifest.exercises {
            assert!(
                read_exercise_file(&exercise.dir, &exercise.name, "task.md").is_some(),
                "missing task.md for {}/{}",
                exercise.dir,
                exercise.name,
            );
            assert!(
                read_exercise_file(&exercise.dir, &exercise.name, "check.sh").is_some(),
                "missing check.sh for {}/{}",
                exercise.dir,
                exercise.name,
            );
        }
    }

    #[test]
    fn missing_file_returns_none() {
        assert!(
            read_exercise_file("06_selinux", "01_enforcing_permissive", "does_not_exist").is_none()
        );
    }
}
