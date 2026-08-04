// Author:      Jeff
// Date:        2026-08-03
// Description: Runtime representation of a single exercise: its manifest metadata
//              plus the logic to run its setup.sh/check.sh against live system state.
// Notes:       Replaces upstream rustlings' RunnableExercise (cargo build/test/clippy
//              pipeline in exercise.rs) -- there's no compilation here, just running
//              embedded scripts and reading their exit status.

use anyhow::Result;

use crate::{
    cmd::{ScriptOutcome, run_script},
    embedded::read_exercise_file,
    manifest::{ExerciseInfo, ExerciseKind},
};

pub struct Exercise {
    pub name: String,
    pub dir: String,
    pub domain: String,
    pub kind: ExerciseKind,
    pub done: bool,
}

impl Exercise {
    pub fn from_info(info: ExerciseInfo) -> Self {
        Self {
            name: info.name,
            dir: info.dir,
            domain: info.domain,
            kind: info.kind,
            done: false,
        }
    }

    // Read the exercise's task prompt
    pub fn task(&self) -> &'static str {
        read_exercise_file(&self.dir, &self.name, "task.md").unwrap_or("(missing task.md)")
    }

    // Read the exercise's on-demand hint, if one exists
    pub fn hint(&self) -> Option<&'static str> {
        read_exercise_file(&self.dir, &self.name, "hint.md")
    }

    // Read the exercise's reference solution, if one exists
    pub fn solution(&self) -> Option<&'static str> {
        read_exercise_file(&self.dir, &self.name, "solution.md")
    }

    // Whether this exercise ships a setup.sh to arrange its starting state
    pub fn has_setup(&self) -> bool {
        read_exercise_file(&self.dir, &self.name, "setup.sh").is_some()
    }

    // Run setup.sh against the live system, if present. A no-op success if absent.
    pub fn run_setup(&self) -> Result<ScriptOutcome> {
        match read_exercise_file(&self.dir, &self.name, "setup.sh") {
            Some(script) => run_script(script),
            None => Ok(ScriptOutcome {
                success: true,
                output: String::new(),
            }),
        }
    }

    // Run check.sh against the live system
    pub fn run_check(&self) -> Result<ScriptOutcome> {
        let script = read_exercise_file(&self.dir, &self.name, "check.sh")
            .unwrap_or("exit 1 # missing check.sh");
        run_script(script)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn dummy_info() -> ExerciseInfo {
        ExerciseInfo {
            name: "01_enforcing_permissive".to_string(),
            dir: "06_selinux".to_string(),
            domain: "Manage security".to_string(),
            kind: ExerciseKind::Standard,
            watch_file: None,
        }
    }

    #[test]
    fn reads_embedded_task_and_hint() {
        let exercise = Exercise::from_info(dummy_info());
        assert!(exercise.task().contains("enforcing"));
        assert!(exercise.hint().is_some());
        assert!(exercise.has_setup());
    }
}
