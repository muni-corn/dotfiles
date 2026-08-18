#!/usr/bin/env python3

"""Timewarrior extension that generates a PDF timesheet.

Reads the standard timew extension input from stdin (config block + JSON
intervals) and produces a formatted A4-landscape PDF timesheet.

Configuration (set via `timew config`):
    reports.timesheet.rate.<tag>      Hourly rate for the given tag (required).
    reports.timesheet.output_dir      Directory to save the PDF (optional;
                                      defaults to $TIMESHEET_OUTPUT_DIR env var,
                                      then the current working directory).

Output:
    Saves the PDF as <tag>.<year>.W<start>-W<end>.pdf and prints the path.
"""

import json
import os
import subprocess
import sys
from dataclasses import dataclass, field
from datetime import date, datetime, timedelta, timezone
from pathlib import Path

from fpdf import FPDF, FontFace
from fpdf.enums import TableBordersLayout

# Tags stripped from description display.
_HIDDEN_TAGS = frozenset({"work", "jira", "next"})

# --- Data model ---


@dataclass
class Entry:
    """A single tracked time interval."""

    description: str
    start: datetime
    end: datetime | None
    duration: timedelta


@dataclass
class Day:
    """All entries for a single calendar day."""

    date: date
    entries: list[Entry] = field(default_factory=list)

    @property
    def total(self) -> timedelta:
        """Sum of all entry durations for this day."""
        return sum((e.duration for e in self.entries), timedelta())

    @property
    def day_name(self) -> str:
        """Abbreviated weekday name, e.g. 'Mon'."""
        return self.date.strftime("%a")


@dataclass
class Week:
    """All days within a single ISO week."""

    label: str
    iso_year: int
    days: list[Day] = field(default_factory=list)

    @property
    def total(self) -> timedelta:
        """Sum of all day totals for this week."""
        return sum((d.total for d in self.days), timedelta())

    @property
    def entry_count(self) -> int:
        """Total number of entries across all days."""
        return sum(len(d.entries) for d in self.days)


# --- Stdin parsing ---


def parse_stdin() -> tuple[dict[str, str], list[dict]]:
    """Parse the timew extension stdin format.

    Returns a tuple of (config dict, intervals list). The config block is the
    section before the first blank line; the JSON array follows.
    """
    text = sys.stdin.read()
    separator = text.find("\n\n")
    if separator == -1:
        return {}, []

    config_text = text[:separator]
    json_text = text[separator + 2 :]

    config: dict[str, str] = {}
    for line in config_text.splitlines():
        if ": " in line:
            key, _, value = line.partition(": ")
            config[key] = value

    intervals: list[dict] = json.loads(json_text) if json_text.strip() else []
    return config, intervals


def extract_filter_tag(config: dict[str, str]) -> str:
    """Return the primary filter tag from the timew config block."""
    raw = config.get("temp.report.tags", "")
    # tags may be comma-separated, multi-word tags are quoted
    tags = [t.strip().strip('"') for t in raw.split(",") if t.strip()]
    if not tags:
        print("error: no filter tags found in timew config", file=sys.stderr)
        sys.exit(1)
    return tags[0]


# --- Interval processing ---


def _parse_timew_ts(ts: str) -> datetime:
    """Parse a timewarrior UTC timestamp to an aware datetime."""
    return datetime.strptime(ts, "%Y%m%dT%H%M%SZ").replace(tzinfo=timezone.utc)


def _entry_description(interval: dict, filter_tag: str) -> str:
    """Build a human-readable description for a single interval.

    Uses the annotation if present, otherwise falls back to the tag list with
    generic and filter tags removed.
    """
    annotation = interval.get("annotation", "").strip()
    if annotation:
        return annotation
    hidden = _HIDDEN_TAGS | {filter_tag}
    visible = [t for t in interval.get("tags", []) if t not in hidden]
    return ", ".join(visible)


def group_intervals(intervals: list[dict], filter_tag: str) -> list[Week]:
    """Group filtered intervals into weeks and days in local time.

    Intervals that do not carry the filter tag are ignored.
    """
    relevant = [i for i in intervals if filter_tag in i.get("tags", [])]
    relevant.sort(key=lambda i: i["start"])

    weeks: dict[tuple[int, int], Week] = {}
    days: dict[date, Day] = {}

    for interval in relevant:
        start_local = _parse_timew_ts(interval["start"]).astimezone()
        end_local: datetime | None = None
        if "end" in interval:
            end_local = _parse_timew_ts(interval["end"]).astimezone()

        duration = (end_local - start_local) if end_local else timedelta()
        d = start_local.date()
        iso = d.isocalendar()
        week_key = (iso.year, iso.week)

        if week_key not in weeks:
            weeks[week_key] = Week(label=f"W{iso.week:02d}", iso_year=iso.year)

        if d not in days:
            day = Day(date=d)
            days[d] = day
            weeks[week_key].days.append(day)

        days[d].entries.append(
            Entry(
                description=_entry_description(interval, filter_tag),
                start=start_local,
                end=end_local,
                duration=duration,
            )
        )

    return [w for _, w in sorted(weeks.items())]


# --- Formatting helpers ---


def fmt_duration(td: timedelta) -> str:
    """Format a timedelta as H:MM:SS."""
    total_s = int(td.total_seconds())
    h = total_s // 3600
    m = (total_s % 3600) // 60
    s = total_s % 60
    return f"{h}:{m:02d}:{s:02d}"


def fmt_time(dt: datetime) -> str:
    """Format a local datetime as H:MM:SS."""
    return dt.strftime("%-H:%M:%S")


def compute_charge(total: timedelta, rate: float) -> float:
    """Compute the billable charge for a given total duration and hourly rate."""
    return round(total.total_seconds() / 3600 * rate, 2)


# --- Font resolution ---


def _find_font_file(family: str, style: str) -> str:
    """Resolve a font file path via fontconfig."""
    result = subprocess.run(
        ["fc-match", "--format=%{file}", f"{family}:style={style}"],
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


# --- PDF generation ---

# Colour palette.
_C_HEADER_BG = (40, 40, 40)
_C_HEADER_FG = (255, 255, 255)
_C_WEEK_BG = (235, 235, 240)
_C_WEEK_FG = (40, 40, 40)
_C_TOTAL_BG = (220, 220, 228)
_C_GRAND_BG = (200, 200, 212)
_C_RULE = (180, 180, 190)


def _register_fonts(pdf: FPDF) -> None:
    """Register Adwaita Sans and Mono fonts into the FPDF instance."""
    pdf.add_font("Sans", style="", fname=_find_font_file("Adwaita Sans", "Regular"))
    pdf.add_font("Sans", style="B", fname=_find_font_file("Adwaita Sans", "Bold"))
    pdf.add_font("Mono", style="", fname=_find_font_file("Adwaita Mono", "Regular"))
    pdf.add_font("Mono", style="B", fname=_find_font_file("Adwaita Mono", "Bold"))


def _draw_page_header(
    pdf: FPDF,
    filter_tag: str,
    date_range: str,
    rate: float,
) -> None:
    """Render the document header above the table."""
    pdf.set_font("Sans", "B", 22)
    pdf.set_text_color(40, 40, 40)
    pdf.cell(0, 12, filter_tag.upper(), new_x="LMARGIN", new_y="NEXT")

    pdf.set_font("Sans", "", 11)
    pdf.set_text_color(80, 80, 80)
    pdf.cell(0, 6, f"Timesheet  ·  {date_range}", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(4)

    pdf.set_draw_color(*_C_RULE)
    pdf.set_line_width(0.4)
    pdf.line(pdf.l_margin, pdf.get_y(), pdf.w - pdf.r_margin, pdf.get_y())
    pdf.ln(6)


def build_pdf(
    weeks: list[Week],
    filter_tag: str,
    rate: float,
) -> FPDF:
    """Render the full timesheet PDF and return the FPDF object.

    Args:
        weeks: Grouped interval data.
        filter_tag: The primary timew tag (e.g. 'orosa').
        rate: Hourly billing rate.
    """
    pdf = FPDF(orientation="landscape", format="A4")
    pdf.set_margins(15, 15, 15)
    pdf.set_auto_page_break(auto=True, margin=20)

    _register_fonts(pdf)

    # Computed values.
    grand_total = sum((w.total for w in weeks), timedelta())
    charge = compute_charge(grand_total, rate)

    all_days = [d for w in weeks for d in w.days]
    first_day = all_days[0].date
    last_day = all_days[-1].date

    date_range_str = f"{first_day}  –  {last_day}"

    # --- Page setup ---
    pdf.add_page()
    _draw_page_header(pdf, filter_tag, date_range_str, rate)

    # Column widths (A4 landscape: 297mm − 30mm margins = 267mm).
    usable_w = int(pdf.w - pdf.l_margin - pdf.r_margin)
    col_date = 26
    col_day = 14
    col_time = 22  # start, end, duration, total each
    col_desc = usable_w - col_date - col_day - col_time * 4

    # FontFace styles.
    header_style = FontFace(
        family="Sans",
        emphasis="B",
        color=_C_HEADER_FG,
        fill_color=_C_HEADER_BG,
    )
    week_style = FontFace(
        family="Sans",
        emphasis="B",
        color=_C_WEEK_FG,
        fill_color=_C_WEEK_BG,
    )
    mono = FontFace(family="Mono")
    mono_bold = FontFace(family="Mono", emphasis="B")
    grand_label_style = FontFace(family="Sans", emphasis="B", fill_color=_C_GRAND_BG)
    grand_value_style = FontFace(family="Mono", emphasis="B", fill_color=_C_GRAND_BG)

    # --- Table ---
    # Use a slightly smaller font so time columns don't wrap.
    pdf.set_font("Sans", "", 9)

    with pdf.table(
        col_widths=(
            col_date,
            col_day,
            col_desc,
            col_time,
            col_time,
            col_time,
            col_time,
        ),
        borders_layout=TableBordersLayout.HORIZONTAL_LINES,  # ty:ignore[unresolved-attribute]
        line_height=6,
        padding=1,
        headings_style=header_style,
        text_align="LEFT",
    ) as table:
        # Column headers.
        hdr = table.row()
        for label in (
            "Date",
            "Day",
            "Description",
            "Start",
            "End",
            "Duration",
            "Total",
        ):
            hdr.cell(label)

        # Data rows.
        for week in weeks:
            # Week separator.
            week_row = table.row()
            week_row.cell(
                f"{week.label}  —  {week.iso_year}",
                colspan=7,
                style=week_style,
            )

            for day in week.days:
                day_n = len(day.entries)
                for i, entry in enumerate(day.entries):
                    row = table.row()
                    is_first = i == 0
                    is_last = i == day_n - 1

                    # Date and day name span all entries for this day.
                    if is_first:
                        row.cell(str(day.date), rowspan=day_n)
                        row.cell(day.day_name, rowspan=day_n)

                    row.cell(entry.description)
                    row.cell(
                        fmt_time(entry.start),
                        style=mono,
                        align="RIGHT",
                    )
                    row.cell(
                        fmt_time(entry.end) if entry.end else "",
                        style=mono,
                        align="RIGHT",
                    )
                    row.cell(fmt_duration(entry.duration), style=mono, align="RIGHT")

                    # Daily total only on the last entry of each day.
                    if is_last:
                        row.cell(
                            fmt_duration(day.total),
                            style=mono_bold,
                            align="RIGHT",
                        )
                    else:
                        row.cell("")

        # Grand total row.
        grand_row = table.row()
        grand_row.cell("Grand total", colspan=6, style=grand_label_style, align="RIGHT")
        grand_row.cell(
            fmt_duration(grand_total), style=grand_value_style, align="RIGHT"
        )

    # Charge summary line: keep it on the same page as the grand total row.
    # Temporarily bypass auto_page_break so the summary can occupy the margin
    # zone (190–200mm) when the table ends close to the bottom of a page.
    _gap = 5
    _line_h = 7
    _hard_bottom = pdf.h - 10  # stay 10mm from physical page edge
    pdf.set_auto_page_break(False)
    if pdf.get_y() + _gap + _line_h > _hard_bottom:
        # truly no room — push to the next page
        pdf.add_page()
        pdf.set_auto_page_break(True, margin=20)
        pdf.ln(_gap * 2)
    else:
        pdf.ln(_gap)
    pdf.set_font("Mono", "", 10)
    pdf.set_text_color(60, 60, 60)
    charge_line = f"{fmt_duration(grand_total)} hrs  ×  ${rate:g}/hr  =  ${charge:,.2f}"
    pdf.cell(0, _line_h, charge_line, new_x="LMARGIN", new_y="NEXT", align="RIGHT")
    pdf.set_auto_page_break(True, margin=20)

    return pdf


def derive_output_path(
    weeks: list[Week],
    filter_tag: str,
    output_dir: Path,
) -> Path:
    """Build the output PDF filename from the week range in the data.

    Format: <tag>.<iso_year>.W<start>-W<end>.pdf
    """
    first_week = weeks[0].label
    last_week = weeks[-1].label
    iso_year = weeks[-1].iso_year
    filename = f"{filter_tag}.{iso_year}.{first_week}-{last_week}.pdf"
    return output_dir / filename


# --- Entry point ---


def main() -> None:
    """Parse timew extension stdin and write a PDF timesheet."""
    config, intervals = parse_stdin()

    filter_tag = extract_filter_tag(config)

    # Hourly rate.
    rate_key = f"reports.timesheet.rate.{filter_tag}"
    rate_str = config.get(rate_key, "").strip()
    if not rate_str:
        print(
            f"error: no hourly rate configured for tag '{filter_tag}'\n"
            f"  hint: timew config {rate_key} <rate>",
            file=sys.stderr,
        )
        sys.exit(1)
    try:
        rate = float(rate_str)
    except ValueError:
        print(f"error: invalid rate value '{rate_str}' for {rate_key}", file=sys.stderr)
        sys.exit(1)

    # Output directory: env var → timew config → cwd.
    output_dir_str = (
        os.environ.get("TIMESHEET_OUTPUT_DIR")
        or config.get("reports.timesheet.output_dir", "")
        or "."
    )
    output_dir = Path(output_dir_str).expanduser().resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    if not intervals:
        print(
            "error: no intervals in input — is the date range correct?", file=sys.stderr
        )
        sys.exit(1)

    weeks = group_intervals(intervals, filter_tag)
    if not weeks:
        print(
            f"error: no intervals matching tag '{filter_tag}' in the given range",
            file=sys.stderr,
        )
        sys.exit(1)

    pdf = build_pdf(weeks, filter_tag, rate)

    output_path = derive_output_path(weeks, filter_tag, output_dir)
    pdf.output(str(output_path))
    print(f"saved: {output_path}")


if __name__ == "__main__":
    main()
