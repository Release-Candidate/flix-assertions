// cargo-deps: regex="1.8.1"
// SPDX-FileCopyrightText:  Copyright 2023 Roland Csaszar
// SPDX-License-Identifier: MIT
//
// Project:  Stainless
// File:     parse_changelog.rs
// Date:     24.Apr.2023
//
// ==============================================================================
//! Run this script using `rust-script parse_changelog.rs`.
//!
//! This parses the Markdown changelog at `CHANGELOG_PATH`, extracts the newest
//! entry and saves that to `OUT_PATH`.
//! It also compares the latest version number parsed from the changelog with
//! the version given as argument and does not write the output file if these
//! two differ. The version number to compare against is supposed to be a Git
//! version tag.

use regex::Regex;
use std::{
    env::args,
    fs::{read_to_string, write},
    process::exit,
};

// The regex to parse the changelog.
const CHANGELOG_REGEX: &str =
    r"\n(##\s+Version\s+(?P<version>[\p{N}\p{P}~]+)\s+(?s).+?)(?:(?:\n##\s+Version)|$)";

// The path to the Changelog file.
const CHANGELOG_PATH: &str = "./CHANGELOG.md";

// The path to the latest changelog file to write to.
const OUT_PATH: &str = "./latest_changelog.md";

//------------------------------------------------------------------------------
fn main() -> () {
    match Regex::new(CHANGELOG_REGEX) {
        Ok(changelog_regex) => parse_changelog(changelog_regex),
        Err(e) => error_exit(&format!("Error compiling changelog regex: {e}")),
    }
}

/// Print the given error message to `stderr` and exit the program.
///
/// ## Arguments
///
/// * `message` - The error message to display.
fn error_exit(message: &str) -> ! {
    eprintln!("{}", message);
    exit(1)
}

/// Parse the changelog for the newest entry.
///
/// Exit the program with an error message on errors.
///
/// ## Arguments
///
/// * `changelog_regex` - The regex to parse the changelog with.
fn parse_changelog(changelog_regex: Regex) {
    match read_to_string(CHANGELOG_PATH) {
        Ok(changelog) => {
            for group in changelog_regex.captures_iter(&changelog) {
                process_match(group);
            }
        }
        Err(e) => error_exit(&format!("Error reading file {CHANGELOG_PATH}: {e}")),
    }
}

/// Process the match group.
///
/// Check the version number and write the latest changelog entry to the file on
/// success, exit the program with an error message on errors.
///
/// ## Arguments
///
/// * `group` - The current match group to process.
fn process_match(group: regex::Captures) {
    let (newest, version) = get_match(group);
    match check_version(version) {
        Ok(_) => println!("Versions match!"),
        Err(m) => error_exit(&m),
    };
    write_to_file(newest);
}

/// Check the given version against the command line argument.
///
/// ## Arguments
///
/// * `version` - The version string to check against the command line arguments.
///
/// ## Returns
///
/// * `true` if the versions match.
/// * `false` else
fn check_version(version: &str) -> Result<(), String> {
    let arg_version: Vec<String> = args().filter(|e| e == version).collect();
    if arg_version.is_empty() {
        Err(format!("Version mismatch, changelog version is {version}!"))
    } else {
        Ok(())
    }
}

/// Write the text `newest` to the file `OUT_PATH`.
///
/// Prints a message about success of failure on `stdout` or `stderr`.
///
/// ## Arguments
///
/// * `newest` - The text to write to the file.
fn write_to_file(newest: &str) -> () {
    match write(OUT_PATH, newest) {
        Ok(_) => println!("OK: written latest changelog to file {OUT_PATH}."),
        Err(e) => error_exit(&format!("Error: writing to file {OUT_PATH}: {e}")),
    }
}

/// Return the parsed text of the latest changelog entry and the latest version.
///
/// Exits the program if not both values have been found.
///
/// ## Arguments
///
/// * `group` - The capture group to process.
///
/// ## Returns
///
/// A tuple `(newest, version)` containing the text of the latest changelog
/// entry and the latest version.
fn get_match(group: regex::Captures) -> (&str, &str) {
    let newest_maybe = group.get(1);
    let version_maybe = group.name("version");
    match (newest_maybe, version_maybe) {
        (Some(n), Some(v)) => (n.as_str(), v.as_str()),
        (_, _) => error_exit("Error parsing the latest changelog entry!"),
    }
}
