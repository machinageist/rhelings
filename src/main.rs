// Author:      Jeff
// Date:        2026-08-03
// Description: Entry point. Shows the safety banner, loads the embedded exercise
//              manifest and on-disk progress state, then enters the run screen (or
//              the list screen if --list is passed).
// Notes:       Run as root, on a disposable VM only -- see banner.rs.

mod app_state;
mod banner;
mod cmd;
mod embedded;
mod exercise;
mod list;
mod manifest;
mod run;
mod term;

use anyhow::{Context, Result};
use clap::Parser;
use std::{
    io::{self, Write},
    process::ExitCode,
};

use app_state::{AppState, StateFileStatus};
use term::{clear_terminal, press_enter_prompt};

#[derive(Parser)]
#[command(
    name = "rhelings",
    version,
    about = "RHCSA drill loop -- mutates real system state. Run on a disposable VM only."
)]
struct Args {
    /// Open the exercise list instead of the current exercise
    #[arg(short, long)]
    list: bool,
}

fn main() -> Result<ExitCode> {
    let args = Args::parse();

    banner::show_and_confirm()?;

    let manifest = manifest::parse().context("Failed to load the exercise manifest")?;
    let (mut app_state, state_file_status) =
        AppState::new(manifest.exercises, manifest.final_message)?;

    let welcome_message = manifest.welcome_message.trim();
    if !welcome_message.is_empty() && matches!(state_file_status, StateFileStatus::NotRead) {
        let mut stdout = io::stdout().lock();
        clear_terminal(&mut stdout)?;
        stdout.write_all(welcome_message.as_bytes())?;
        stdout.write_all(b"\n\nPress ENTER to continue ")?;
        press_enter_prompt(&mut stdout)?;
    }

    if args.list {
        list::list(&mut app_state)?;
    } else {
        run::run(&mut app_state)?;
    }

    Ok(ExitCode::SUCCESS)
}
