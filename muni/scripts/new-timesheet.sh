#!/usr/bin/env bash
set -euo pipefail

# Generates a new timesheet for $TAG from the day after the last recorded date
# to last Sunday, then saves it with the proper filename format.
#
# Usage: ./new-timesheet.sh <TAG>

TAG="${1:?usage: $0 <TAG>}"

# hourly rates per tag
declare -A RATES=(
    [orosa]=50
)

RATE="${RATES[$TAG]:-}"
if [[ -z "$RATE" ]]; then
    echo "error: no hourly rate configured for tag '$TAG'" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# find the latest date recorded across all matching timesheet files
LATEST=""
for f in "$SCRIPT_DIR/$TAG".*.txt; do
    [[ -e "$f" ]] || { echo "error: no files matching '$TAG.*.txt' found" >&2; exit 1; }
    # extract ISO dates (YYYY-MM-DD) from each file, keep the last one found
    last_date="$(grep -oP '\d{4}-\d{2}-\d{2}' "$f" | sort | tail -1)"
    if [[ -n "$last_date" && "$last_date" > "$LATEST" ]]; then
        LATEST="$last_date"
    fi
done

if [[ -z "$LATEST" ]]; then
    echo "error: could not determine latest date from '$TAG.*.txt' files" >&2
    exit 1
fi

echo "latest recorded date: $LATEST"

# first day is the day after the last recorded date
START="$(task calc $LATEST + 1 day)"

# end is start of this week
END="$(task calc sow)"

echo "generating timesheet from $START to $END"

TMPFILE="$(mktemp /tmp/timesheet-XXXXXX.txt)"
timew summary "$TAG" "$START" - sow > "$TMPFILE"

# derive week numbers from the actual dates present in the report
FIRST_DATE="$(grep -oP '\d{4}-\d{2}-\d{2}' "$TMPFILE" | sort | head -1)"
LAST_DATE="$(grep -oP '\d{4}-\d{2}-\d{2}' "$TMPFILE" | sort | tail -1)"

if [[ -z "$FIRST_DATE" || -z "$LAST_DATE" ]]; then
    echo "error: no dates found in generated report" >&2
    rm "$TMPFILE"
    exit 1
fi

START_WEEK="$(date -d "$FIRST_DATE" +%V)"
END_WEEK="$(date -d "$LAST_DATE" +%V)"

# %G = ISO week-numbering year
YEAR="$(date -d "$LAST_DATE" +%G)"

FILENAME="$SCRIPT_DIR/$TAG.$YEAR.W${START_WEEK}-W${END_WEEK}.txt"
mv "$TMPFILE" "$FILENAME"

# extract the grand total (last H:MM:SS on the total line) and compute charge
TOTAL_HMS="$(grep -oP '\d+:\d{2}:\d{2}' "$FILENAME" | tail -1)"
IFS=: read -r T_H T_M T_S <<< "$TOTAL_HMS"

echo total time: $T_H hours, $T_M minutes, $T_S seconds

CHARGE=$(fend "@noapprox ($T_H hr + $T_M min + $T_S sec) * $RATE / hr to 2 dp")

echo total charge: \$$CHARGE

echo -e '- - - - - - - - - -\n' >> "$FILENAME"
printf '%s hrs * $%s / hr = $%s' "$TOTAL_HMS" "$RATE" "$CHARGE" >> "$FILENAME"

echo "saved: $FILENAME"
