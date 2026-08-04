// Author:      Jeff
// Date:        2026-08-03
// Description: Tracks which exercise is current and which are done, persisted to a
//              plain-text state file so progress survives process restarts --
//              including the restart caused by a reboot mid-exercise.
// Notes:       The state-file format is ported byte-for-byte from upstream rustlings'
//              app_state.rs. That's deliberate: a reboot exercise's check.sh can only
//              tell "you haven't rebooted yet" apart from "you rebooted and fixed it"
//              because this file's current-exercise pointer survives the restart.
//              Upstream's parallel check-all-exercises pass (re-verifying every done
//              exercise by recompiling it) is dropped -- re-running every check.sh
//              automatically would itself mutate real system state, which isn't
//              something to do without the user asking for it.

use anyhow::{Context, Result, bail};
use std::{
    collections::HashSet,
    fs::{File, OpenOptions},
    io::{Read, Seek, Write},
};

use crate::{exercise::Exercise, manifest::ExerciseInfo};

const STATE_FILE_NAME: &str = ".rhelings-state.txt";
const STATE_FILE_HEADER: &[u8] = b"DON'T EDIT THIS FILE!\n\n";

#[must_use]
pub enum ExercisesProgress {
    AllDone,
    NewPending,
    CurrentPending,
}

pub enum StateFileStatus {
    Read,
    NotRead,
}

pub struct AppState {
    current_exercise_ind: usize,
    exercises: Vec<Exercise>,
    n_done: u32,
    final_message: String,
    state_file: File,
    file_buf: Vec<u8>,
}

impl AppState {
    pub fn new(
        exercise_infos: Vec<ExerciseInfo>,
        final_message: String,
    ) -> Result<(Self, StateFileStatus)> {
        let mut state_file = OpenOptions::new()
            .create(true)
            .read(true)
            .write(true)
            .truncate(false)
            .open(STATE_FILE_NAME)
            .with_context(|| {
                format!("Failed to open or create the state file {STATE_FILE_NAME}")
            })?;

        let mut exercises = exercise_infos
            .into_iter()
            .map(Exercise::from_info)
            .collect::<Vec<_>>();

        let mut current_exercise_ind = 0;
        let mut n_done = 0;
        let mut file_buf = Vec::with_capacity(2048);

        let state_file_status = 'block: {
            if state_file.read_to_end(&mut file_buf).is_err() {
                break 'block StateFileStatus::NotRead;
            }

            // See `Self::write` for the file format.
            let mut lines = file_buf.split(|c| *c == b'\n').skip(2);

            let Some(current_exercise_name) = lines.next() else {
                break 'block StateFileStatus::NotRead;
            };

            if current_exercise_name.is_empty() || lines.next().is_none() {
                break 'block StateFileStatus::NotRead;
            }

            let mut done_exercises = HashSet::with_capacity(exercises.len());
            for done_exercise_name in lines {
                if done_exercise_name.is_empty() {
                    break;
                }
                done_exercises.insert(done_exercise_name);
            }

            for (ind, exercise) in exercises.iter_mut().enumerate() {
                if done_exercises.contains(exercise.name.as_bytes()) {
                    exercise.done = true;
                    n_done += 1;
                }

                if exercise.name.as_bytes() == current_exercise_name {
                    current_exercise_ind = ind;
                }
            }

            StateFileStatus::Read
        };

        file_buf.clear();
        file_buf.extend_from_slice(STATE_FILE_HEADER);

        let slf = Self {
            current_exercise_ind,
            exercises,
            n_done,
            final_message,
            state_file,
            file_buf,
        };

        Ok((slf, state_file_status))
    }

    pub fn current_exercise_ind(&self) -> usize {
        self.current_exercise_ind
    }

    pub fn exercises(&self) -> &[Exercise] {
        &self.exercises
    }

    pub fn n_done(&self) -> u32 {
        self.n_done
    }

    pub fn current_exercise(&self) -> &Exercise {
        &self.exercises[self.current_exercise_ind]
    }

    pub fn final_message(&self) -> &str {
        &self.final_message
    }

    // Write the state file.
    // - Line 1: a comment. Line 2: empty.
    // - Line 3: the current exercise's name, always newline-terminated.
    // - Line 4: empty. Remaining lines: names of done exercises.
    fn write(&mut self) -> Result<()> {
        self.file_buf.truncate(STATE_FILE_HEADER.len());

        // Indexes directly instead of going through `current_exercise()` so the
        // borrow checker can see this only touches `self.exercises`, not all of
        // `self` -- which would conflict with the `self.file_buf` borrow below.
        self.file_buf
            .extend_from_slice(self.exercises[self.current_exercise_ind].name.as_bytes());
        self.file_buf.push(b'\n');

        for exercise in &self.exercises {
            if exercise.done {
                self.file_buf.push(b'\n');
                self.file_buf.extend_from_slice(exercise.name.as_bytes());
            }
        }

        self.state_file
            .rewind()
            .with_context(|| format!("Failed to rewind the state file {STATE_FILE_NAME}"))?;
        self.state_file
            .set_len(0)
            .with_context(|| format!("Failed to truncate the state file {STATE_FILE_NAME}"))?;
        self.state_file
            .write_all(&self.file_buf)
            .with_context(|| format!("Failed to write the state file {STATE_FILE_NAME}"))?;

        Ok(())
    }

    pub fn set_current_exercise_ind(&mut self, exercise_ind: usize) -> Result<()> {
        if exercise_ind == self.current_exercise_ind {
            return Ok(());
        }

        if exercise_ind >= self.exercises.len() {
            bail!(BAD_INDEX_ERR);
        }

        self.current_exercise_ind = exercise_ind;
        self.write()
    }

    // Set the done status of an exercise. Returns true if it actually changed.
    fn set_status(&mut self, exercise_ind: usize, done: bool) -> Result<bool> {
        let exercise = self
            .exercises
            .get_mut(exercise_ind)
            .context(BAD_INDEX_ERR)?;

        if exercise.done == done {
            return Ok(false);
        }

        exercise.done = done;
        if done {
            self.n_done += 1;
        } else {
            self.n_done -= 1;
        }

        Ok(true)
    }

    pub fn set_pending(&mut self, exercise_ind: usize) -> Result<()> {
        if self.set_status(exercise_ind, false)? {
            self.write()?;
        }
        Ok(())
    }

    // Return the index of the next pending exercise, wrapping, or `None` if all are done.
    fn next_pending_exercise_ind(&self) -> Option<usize> {
        let next_ind = self.current_exercise_ind + 1;
        self.exercises
            .get(next_ind..)
            .and_then(|later| later.iter().position(|e| !e.done).map(|ind| next_ind + ind))
            .or_else(|| {
                self.exercises[..self.current_exercise_ind]
                    .iter()
                    .position(|e| !e.done)
            })
    }

    // Mark the current exercise done and move to the next pending one, if any.
    pub fn done_current_exercise(&mut self) -> Result<ExercisesProgress> {
        if self.set_status(self.current_exercise_ind, true)? {
            self.write()?;
        }

        if let Some(ind) = self.next_pending_exercise_ind() {
            self.set_current_exercise_ind(ind)?;
            return Ok(ExercisesProgress::NewPending);
        }

        Ok(ExercisesProgress::AllDone)
    }
}

const BAD_INDEX_ERR: &str = "The current exercise index is higher than the number of exercises";

#[cfg(test)]
mod tests {
    use super::*;
    use crate::manifest::ExerciseKind;

    fn dummy_exercise(name: &str) -> Exercise {
        Exercise::from_info(ExerciseInfo {
            name: name.to_string(),
            dir: "06_selinux".to_string(),
            domain: "Manage security".to_string(),
            kind: ExerciseKind::Standard,
            watch_file: None,
        })
    }

    fn dummy_app_state(state_file: File) -> AppState {
        AppState {
            current_exercise_ind: 0,
            exercises: vec![
                dummy_exercise("a"),
                dummy_exercise("b"),
                dummy_exercise("c"),
            ],
            n_done: 0,
            final_message: String::new(),
            state_file,
            file_buf: Vec::new(),
        }
    }

    #[test]
    fn next_pending_exercise() {
        let mut app_state = dummy_app_state(tempfile::tempfile().unwrap());

        let mut assert = |done: [bool; 3], expected: [Option<usize>; 3]| {
            for (exercise, done) in app_state.exercises.iter_mut().zip(done) {
                exercise.done = done;
            }
            for (ind, expected) in expected.into_iter().enumerate() {
                app_state.current_exercise_ind = ind;
                assert_eq!(
                    app_state.next_pending_exercise_ind(),
                    expected,
                    "done={done:?}, ind={ind}"
                );
            }
        };

        assert([true, true, true], [None, None, None]);
        assert([false, false, false], [Some(1), Some(2), Some(0)]);
        assert([false, true, true], [None, Some(0), Some(0)]);
        assert([true, false, true], [Some(1), None, Some(1)]);
        assert([true, true, false], [Some(2), Some(2), None]);
    }

    #[test]
    fn state_file_round_trip() -> Result<()> {
        let dir = tempfile::tempdir()?;
        let state_path = dir.path().join(STATE_FILE_NAME);

        let make_info = |name: &str| ExerciseInfo {
            name: name.to_string(),
            dir: "06_selinux".to_string(),
            domain: "Manage security".to_string(),
            kind: ExerciseKind::Standard,
            watch_file: None,
        };

        let state_file = OpenOptions::new()
            .create(true)
            .read(true)
            .write(true)
            .truncate(false)
            .open(&state_path)?;

        // Mirrors the priming `AppState::new` does before constructing `Self`.
        let mut app_state = AppState {
            current_exercise_ind: 0,
            exercises: vec![
                Exercise::from_info(make_info("a")),
                Exercise::from_info(make_info("b")),
            ],
            n_done: 0,
            final_message: String::new(),
            state_file,
            file_buf: STATE_FILE_HEADER.to_vec(),
        };

        // Marks "a" done, advances current to "b", and persists both to disk.
        let _progress = app_state.done_current_exercise()?;

        let mut reopened = OpenOptions::new().read(true).open(&state_path)?;
        let mut buf = Vec::new();
        reopened.read_to_end(&mut buf)?;
        let text = String::from_utf8(buf).unwrap();
        let mut lines = text.split('\n');

        assert_eq!(lines.next(), Some("DON'T EDIT THIS FILE!"));
        assert_eq!(lines.next(), Some(""));
        assert_eq!(
            lines.next(),
            Some("b"),
            "current exercise should now be `b`: {text}"
        );
        assert_eq!(lines.next(), Some(""));
        assert_eq!(
            lines.next(),
            Some("a"),
            "done exercise `a` should be recorded: {text}"
        );

        Ok(())
    }
}
