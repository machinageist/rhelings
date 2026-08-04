// Author:      Jeff
// Date:        2026-08-03
// Description: Renders the current exercise (task prompt, last check output, hint,
//              solution) and drives check/setup/hint/solution/next actions.
// Notes:       Adapted from upstream rustlings' watch/state.rs. There is no file
//              watching here (see run.rs) -- `run_check` is only ever invoked by an
//              explicit key press. `done_this_visit` mirrors upstream's DoneStatus:
//              a passing check is only persisted to AppState (and only then may
//              advance to the next exercise) once the user presses `n`, so a passing
//              check doesn't silently record progress the user hasn't acted on.

use anyhow::Result;
use crossterm::{
    QueueableCommand,
    style::{
        Attribute, Attributes, Color, ResetColor, SetAttribute, SetAttributes, SetForegroundColor,
    },
    terminal,
};
use std::io::{StdoutLock, Write};

use crate::{
    app_state::{AppState, ExercisesProgress},
    manifest::ExerciseKind,
    term::{clear_terminal, progress_bar},
};

const HEADING_ATTRIBUTES: Attributes = Attributes::none()
    .with(Attribute::Bold)
    .with(Attribute::Underlined);

pub struct RunState<'a> {
    app_state: &'a mut AppState,
    output: String,
    show_hint: bool,
    show_solution: bool,
    done_this_visit: bool,
    term_width: u16,
}

impl<'a> RunState<'a> {
    pub fn build(app_state: &'a mut AppState) -> Result<Self> {
        let term_width = terminal::size()?.0;

        let mut slf = Self {
            app_state,
            output: String::new(),
            show_hint: false,
            show_solution: false,
            done_this_visit: false,
            term_width,
        };

        // Arrange the exercise's starting state the first time it's opened.
        // Not re-run automatically on revisits to an already-done exercise --
        // only the explicit `r` key does that.
        if !slf.app_state.current_exercise().done && slf.app_state.current_exercise().has_setup() {
            let outcome = slf.app_state.current_exercise().run_setup()?;
            slf.output = outcome.output;
        }

        Ok(slf)
    }

    pub fn run_setup(&mut self) -> Result<()> {
        let outcome = self.app_state.current_exercise().run_setup()?;
        self.output = outcome.output;
        self.show_hint = false;
        self.show_solution = false;
        self.done_this_visit = false;

        // If this exercise was previously marked done, deliberately re-breaking
        // its state with setup.sh must also unmark it -- otherwise the list
        // screen would keep showing it as DONE while it's actually broken again.
        self.app_state
            .set_pending(self.app_state.current_exercise_ind())?;

        Ok(())
    }

    pub fn run_check(&mut self) -> Result<()> {
        let outcome = self.app_state.current_exercise().run_check()?;
        self.output = outcome.output;
        self.done_this_visit = outcome.success;
        Ok(())
    }

    pub fn show_hint(&mut self) {
        self.show_hint = true;
    }

    pub fn set_term_width(&mut self, width: u16) {
        self.term_width = width;
    }

    pub fn show_solution(&mut self) {
        if self.done_this_visit {
            self.show_solution = true;
        }
    }

    // Persist the current exercise as done and move on, if the last check passed.
    pub fn next_exercise(&mut self) -> Result<ExercisesProgress> {
        if !self.done_this_visit {
            return Ok(ExercisesProgress::CurrentPending);
        }

        self.app_state.done_current_exercise()
    }

    pub fn render(&self, stdout: &mut StdoutLock) -> anyhow::Result<()> {
        stdout.write_all(b"\n")?;
        clear_terminal(stdout)?;

        let exercise = self.app_state.current_exercise();

        stdout
            .queue(SetAttributes(HEADING_ATTRIBUTES))?
            .queue(SetForegroundColor(Color::Cyan))?;
        write!(stdout, "{} / {}", exercise.domain, exercise.name)?;
        stdout.queue(ResetColor)?;
        stdout.write_all(b"\n\n")?;

        stdout.write_all(exercise.task().trim().as_bytes())?;
        stdout.write_all(b"\n\n")?;

        if !self.output.is_empty() {
            stdout
                .queue(SetAttributes(HEADING_ATTRIBUTES))?
                .queue(SetForegroundColor(Color::Cyan))?;
            stdout.write_all(b"Output")?;
            stdout.queue(ResetColor)?;
            stdout.write_all(b"\n")?;
            stdout.write_all(self.output.trim_end().as_bytes())?;
            stdout.write_all(b"\n\n")?;
        }

        if self.show_hint
            && let Some(hint) = exercise.hint()
        {
            stdout
                .queue(SetAttributes(HEADING_ATTRIBUTES))?
                .queue(SetForegroundColor(Color::Cyan))?;
            stdout.write_all(b"Hint")?;
            stdout.queue(ResetColor)?;
            stdout.write_all(b"\n")?;
            stdout.write_all(hint.trim().as_bytes())?;
            stdout.write_all(b"\n\n")?;
        }

        if self.show_solution
            && let Some(solution) = exercise.solution()
        {
            stdout
                .queue(SetAttributes(HEADING_ATTRIBUTES))?
                .queue(SetForegroundColor(Color::Cyan))?;
            stdout.write_all(b"Solution")?;
            stdout.queue(ResetColor)?;
            stdout.write_all(b"\n")?;
            stdout.write_all(solution.trim().as_bytes())?;
            stdout.write_all(b"\n\n")?;
        }

        if self.done_this_visit {
            stdout
                .queue(SetAttribute(Attribute::Bold))?
                .queue(SetForegroundColor(Color::Green))?;
            stdout.write_all(b"Exercise done - press n for the next one\n\n")?;
            stdout.queue(ResetColor)?;
        }

        progress_bar(
            stdout,
            self.app_state.n_done(),
            self.app_state.exercises().len() as u32,
            self.term_width,
        )?;
        stdout.write_all(b"\n\n")?;

        self.show_prompt(stdout, exercise.kind)?;

        Ok(())
    }

    fn show_prompt(&self, stdout: &mut StdoutLock, kind: ExerciseKind) -> anyhow::Result<()> {
        let mut show_key = |key: &str, postfix: &str| -> anyhow::Result<()> {
            stdout.queue(SetAttribute(Attribute::Bold))?;
            stdout.write_all(key.as_bytes())?;
            stdout.queue(ResetColor)?;
            stdout.write_all(postfix.as_bytes())?;
            Ok(())
        };

        if self.done_this_visit {
            show_key("n", ":next / ")?;
        }

        let check_label = match kind {
            ExerciseKind::Standard => ":check / ",
            ExerciseKind::Reboot => ":check (reboot first, then rerun rhelings) / ",
        };
        show_key("c", check_label)?;

        if !self.show_hint {
            show_key("h", ":hint / ")?;
        }
        show_key("r", ":reset (rerun setup) / ")?;
        show_key("l", ":list / ")?;
        show_key("q", ":quit ")?;

        stdout.flush()?;
        Ok(())
    }
}
