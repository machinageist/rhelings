// Author:      Jeff
// Date:        2026-08-03
// Description: The startup warning banner -- the only safety mechanism rhelings has.
// Notes:       There is no sandbox and no simulation layer anywhere in this tool.
//              Every exercise runs real commands against the real system it's
//              launched on (SELinux modes/contexts, and in later milestones LVM,
//              firewalld, users, boot config). This banner is shown on every launch
//              and requires an explicit keypress -- it is not a one-time,
//              dismiss-forever prompt.

use anyhow::Result;
use crossterm::{
    QueueableCommand,
    style::{Attribute, Color, ResetColor, SetAttribute, SetForegroundColor},
};
use std::io::{self, Write};

use crate::term::press_enter_prompt;

const BANNER: &str = "\
+-----------------------------------------------------------------------+
| rhelings changes REAL system state.                                   |
|                                                                         |
| SELinux modes and contexts today; LVM, firewalld, users, and boot     |
| config in later milestones. There is no sandbox and nothing here is   |
| simulated -- every check and setup script runs for real.              |
|                                                                         |
| Run this ONLY on a disposable VM you can destroy and rebuild --       |
| never on a system you care about. Run it as root.                     |
+-----------------------------------------------------------------------+
";

// Print the warning banner and block until the user acknowledges it
pub fn show_and_confirm() -> Result<()> {
    let mut stdout = io::stdout().lock();

    stdout
        .queue(SetAttribute(Attribute::Bold))?
        .queue(SetForegroundColor(Color::Red))?;
    stdout.write_all(BANNER.as_bytes())?;
    stdout.queue(ResetColor)?;
    stdout.write_all(b"\nPress ENTER to continue ")?;

    press_enter_prompt(&mut stdout)?;

    Ok(())
}
