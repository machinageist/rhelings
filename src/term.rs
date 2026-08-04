// Author:      Jeff
// Date:        2026-08-03
// Description: Terminal-rendering primitives shared by the list and run screens.
// Notes:       Ported from upstream rustlings' term.rs, with the file-link/canonical-
//              path machinery dropped -- there's no `.rs` file to link to, since each
//              exercise is a directory of markdown/bash, not a single source file.
//              CheckProgressVisualizer and ProgressCounter are also dropped along with
//              upstream's parallel check-all-exercises feature (see app_state.rs).

use crossterm::{
    QueueableCommand,
    cursor::MoveTo,
    style::{Color, SetForegroundColor},
    terminal::{Clear, ClearType},
};
use std::io::{self, BufRead, StdoutLock, Write};

pub struct MaxLenWriter<'a, 'lock> {
    pub stdout: &'a mut StdoutLock<'lock>,
    len: usize,
    max_len: usize,
}

impl<'a, 'lock> MaxLenWriter<'a, 'lock> {
    pub fn new(stdout: &'a mut StdoutLock<'lock>, max_len: usize) -> Self {
        Self {
            stdout,
            len: 0,
            max_len,
        }
    }
}

pub trait CountedWrite<'lock> {
    fn write_ascii(&mut self, ascii: &[u8]) -> io::Result<()>;
    fn write_str(&mut self, unicode: &str) -> io::Result<()>;
    fn stdout(&mut self) -> &mut StdoutLock<'lock>;
}

impl<'lock> CountedWrite<'lock> for MaxLenWriter<'_, 'lock> {
    fn write_ascii(&mut self, ascii: &[u8]) -> io::Result<()> {
        let n = ascii.len().min(self.max_len.saturating_sub(self.len));
        if n > 0 {
            self.stdout.write_all(&ascii[..n])?;
            self.len += n;
        }
        Ok(())
    }

    fn write_str(&mut self, unicode: &str) -> io::Result<()> {
        if let Some((ind, c)) = unicode
            .char_indices()
            .take(self.max_len.saturating_sub(self.len))
            .last()
        {
            self.stdout
                .write_all(&unicode.as_bytes()[..ind + c.len_utf8()])?;
            self.len += ind + 1;
        }
        Ok(())
    }

    fn stdout(&mut self) -> &mut StdoutLock<'lock> {
        self.stdout
    }
}

impl<'a> CountedWrite<'a> for StdoutLock<'a> {
    fn write_ascii(&mut self, ascii: &[u8]) -> io::Result<()> {
        self.write_all(ascii)
    }

    fn write_str(&mut self, unicode: &str) -> io::Result<()> {
        self.write_all(unicode.as_bytes())
    }

    fn stdout(&mut self) -> &mut StdoutLock<'a> {
        self
    }
}

pub fn clear_terminal(stdout: &mut StdoutLock) -> io::Result<()> {
    stdout
        .queue(MoveTo(0, 0))?
        .queue(Clear(ClearType::All))?
        .queue(Clear(ClearType::Purge))
        .map(|_| ())
}

pub fn press_enter_prompt(stdout: &mut StdoutLock) -> io::Result<()> {
    stdout.flush()?;
    io::stdin().lock().read_until(b'\n', &mut Vec::new())?;
    stdout.write_all(b"\n")
}

pub fn progress_bar<'a>(
    writer: &mut impl CountedWrite<'a>,
    progress: u32,
    total: u32,
    term_width: u16,
) -> io::Result<()> {
    const PREFIX: &[u8] = b"Progress: [";
    const PREFIX_WIDTH: u16 = PREFIX.len() as u16;
    const POSTFIX_WIDTH: u16 = "] xxx/xxx".len() as u16;
    const WRAPPER_WIDTH: u16 = PREFIX_WIDTH + POSTFIX_WIDTH;
    const MIN_LINE_WIDTH: u16 = WRAPPER_WIDTH + 4;

    debug_assert!(total <= 999);
    debug_assert!(progress <= total);

    if term_width < MIN_LINE_WIDTH {
        writer.write_ascii(b"Progress: ")?;
        return writer.write_ascii(format!("{progress}/{total}").as_bytes());
    }

    let stdout = writer.stdout();
    stdout.write_all(PREFIX)?;

    let width = u32::from(term_width - WRAPPER_WIDTH);
    let filled = (width * progress) / total;

    stdout.queue(SetForegroundColor(Color::Green))?;
    for _ in 0..filled {
        stdout.write_all(b"#")?;
    }

    if filled < width {
        stdout.write_all(b">")?;

        let width_minus_filled = width - filled;
        if width_minus_filled > 1 {
            stdout.queue(SetForegroundColor(Color::Red))?;
            for _ in 1..width_minus_filled {
                stdout.write_all(b"-")?;
            }
        }
    }

    stdout.queue(SetForegroundColor(Color::Reset))?;

    write!(stdout, "] {progress:>3}/{total}")
}
