// Author:      Jeff
// Date:        2026-08-03
// Description: Runs an embedded shell script string against the live system and
//              captures its combined output and exit status.
// Notes:       Deliberately tiny compared to upstream rustlings' cargo-specific
//              CmdRunner (build/test/clippy pipeline in a temp workspace) -- there is
//              no compile step here, just one process spawn per check or setup run.
//              Scripts are piped in via `bash -c`, never extracted to disk first.

use anyhow::{Context, Result};
use std::process::Command;

pub struct ScriptOutcome {
    pub success: bool,
    pub output: String,
}

// Run a shell script string with bash -c and capture combined stdout/stderr
pub fn run_script(script: &str) -> Result<ScriptOutcome> {
    let output = Command::new("bash")
        .arg("-c")
        .arg(script)
        .output()
        .context("Failed to spawn bash")?;

    let mut combined = String::from_utf8_lossy(&output.stdout).into_owned();
    combined.push_str(&String::from_utf8_lossy(&output.stderr));

    Ok(ScriptOutcome {
        success: output.status.success(),
        output: combined,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn captures_success_and_output() {
        let outcome = run_script("echo hello; exit 0").unwrap();
        assert!(outcome.success);
        assert!(outcome.output.contains("hello"));
    }

    #[test]
    fn captures_failure() {
        let outcome = run_script("echo oops >&2; exit 1").unwrap();
        assert!(!outcome.success);
        assert!(outcome.output.contains("oops"));
    }
}
