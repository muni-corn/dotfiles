#!/usr/bin/env python3
"""Generate a new PDF timesheet for a given tag.

Scans existing timesheet files to find the latest recorded date, then
invokes the timesheet timew extension over the range from the day after
that date to the start of the current ISO week (Monday).

Usage:
    python src/new_timesheet.py <TAG>

The TAG must have a matching hourly rate in your timewarrior config:
    timew config reports.timesheet.rate.<TAG> <rate>

The output PDF is saved alongside existing timesheet files in the same
directory as this script's parent (the invoices directory).
"""

import os
import re
import subprocess
import sys
from datetime import date, timedelta
from pathlib import Path


# Pattern for ISO dates embedded in filenames or file content.
_DATE_RE = re.compile(r"\d{4}-\d{2}-\d{2}")
# Pattern for PDF filenames: tag.YEAR.WXX-WYY.pdf
_PDF_FILENAME_RE = re.compile(r"\.(\d{4})\.W(\d+)-W(\d+)\.pdf$")


def find_latest_date(tag: str, search_dir: Path) -> date | None:
    """Return the latest ISO date recorded across all matching timesheet files.

    Checks .txt file contents for embedded dates (YYYY-MM-DD). Falls back to
    deriving the last Sunday of the final week from .pdf filenames.
    """
    latest: date | None = None

    # Scan .txt content for dates.
    for txt_file in search_dir.glob(f"{tag}.*.txt"):
        content = txt_file.read_text(errors="replace")
        for match in _DATE_RE.finditer(content):
            try:
                d = date.fromisoformat(match.group())
            except ValueError:
                continue
            if latest is None or d > latest:
                latest = d

    if latest is not None:
        return latest

    # Fall back to deriving dates from PDF filenames.
    for pdf_file in search_dir.glob(f"{tag}.*.pdf"):
        m = _PDF_FILENAME_RE.search(pdf_file.name)
        if not m:
            continue
        year = int(m.group(1))
        last_week = int(m.group(3))
        # ISO week date: last day (Sunday) of the given week.
        try:
            sunday = date.fromisocalendar(year, last_week, 7)
        except ValueError:
            continue
        if latest is None or sunday > latest:
            latest = sunday

    return latest


def start_of_current_week() -> date:
    """Return the Monday of the current ISO week."""
    today = date.today()
    return today - timedelta(days=today.weekday())


def main() -> None:
    """Compute date range and invoke the timew timesheet extension."""
    if len(sys.argv) < 2:
        print(f"usage: {sys.argv[0]} <TAG>", file=sys.stderr)
        sys.exit(1)

    tag = sys.argv[1]
    # Invoices directory is the parent of this script's directory.
    invoices_dir = Path.cwd()

    latest = find_latest_date(tag, invoices_dir)
    if latest is None:
        print(
            f"error: no existing timesheet files found for tag '{tag}' in {invoices_dir}",
            file=sys.stderr,
        )
        sys.exit(1)

    print(f"latest recorded date: {latest}")

    start = latest + timedelta(days=1)
    end = start_of_current_week()

    if start >= end:
        print(
            f"error: start date {start} is not before end date {end} — "
            "nothing new to record",
            file=sys.stderr,
        )
        sys.exit(1)

    print(
        f"generating timesheet from {start} to {end - timedelta(days=1)} (sow = {end})"
    )

    env = {**os.environ, "TIMESHEET_OUTPUT_DIR": str(invoices_dir)}
    result = subprocess.run(
        ["timew", "report", "timesheet", tag, str(start), "-", "sow"],
        env=env,
    )
    sys.exit(result.returncode)


if __name__ == "__main__":
    main()
