// Author:      Jeff
// Date:        2026-08-03
// Description: Entry point and event loop for the run screen -- the default view,
//              showing the current exercise and driving check/hint/solution/next
//              actions from explicit key presses.
// Notes:       Adapted from upstream rustlings' watch.rs, with the notify file-watcher
//              thread and its terminal-input-pausing machinery dropped entirely --
//              nothing here watches a file, since exercises are multi-command shell
//              tasks against live state, not a single edited source file (see
//              run/state.rs).

use anyhow::{Context, Result, bail};
use crossterm::{
    QueueableCommand, cursor,
    event::{self, Event, KeyCode, KeyEventKind},
    terminal::{
        DisableLineWrap, EnableLineWrap, EnterAlternateScreen, LeaveAlternateScreen,
        disable_raw_mode, enable_raw_mode,
    },
};
use std::io::{self, IsTerminal, StdoutLock, Write};

use crate::{
    app_state::{AppState, ExercisesProgress},
    list,
    run::state::RunState,
    term::clear_terminal,
};

pub mod state;

fn handle_run(app_state: &mut AppState, stdout: &mut StdoutLock) -> Result<()> {
    'outer: loop {
        let mut run_state = RunState::build(app_state)?;
        run_state.render(stdout)?;

        loop {
            match event::read().context("Failed to read terminal event")? {
                Event::Key(key) => {
                    match key.kind {
                        KeyEventKind::Release => continue,
                        KeyEventKind::Press | KeyEventKind::Repeat => (),
                    }

                    match key.code {
                        KeyCode::Char('q') => return Ok(()),
                        KeyCode::Char('c') => run_state.run_check()?,
                        KeyCode::Char('h') => run_state.show_hint(),
                        KeyCode::Char('s') => run_state.show_solution(),
                        KeyCode::Char('r') => run_state.run_setup()?,
                        KeyCode::Char('l') => {
                            drop(run_state);
                            list::list(app_state)?;
                            continue 'outer;
                        }
                        KeyCode::Char('n') => match run_state.next_exercise()? {
                            ExercisesProgress::NewPending => continue 'outer,
                            ExercisesProgress::AllDone => {
                                clear_terminal(stdout)?;
                                stdout.write_all(app_state.final_message().trim().as_bytes())?;
                                stdout.write_all(b"\n")?;
                                return Ok(());
                            }
                            ExercisesProgress::CurrentPending => (),
                        },
                        _ => continue,
                    }
                }
                Event::Resize(width, _height) => run_state.set_term_width(width),
                _ => continue,
            }

            run_state.render(stdout)?;
        }
    }
}

pub fn run(app_state: &mut AppState) -> Result<()> {
    if !io::stdout().is_terminal() {
        bail!("Unsupported or missing terminal/TTY");
    }

    let mut stdout = io::stdout().lock();
    stdout
        .queue(EnterAlternateScreen)?
        .queue(cursor::Hide)?
        .queue(DisableLineWrap)?;
    enable_raw_mode()?;

    let res = handle_run(app_state, &mut stdout);

    stdout
        .queue(LeaveAlternateScreen)?
        .queue(cursor::Show)?
        .queue(EnableLineWrap)?
        .flush()?;
    disable_raw_mode()?;

    res
}
