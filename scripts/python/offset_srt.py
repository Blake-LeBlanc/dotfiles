import re
import sys
from datetime import datetime, timedelta
from pathlib import Path


def parse_timestamp(timestamp):
    """Parse SRT timestamp format: HH:MM:SS,mmm"""
    time_str = timestamp.replace(",", ".")
    dt = datetime.strptime(time_str, "%H:%M:%S.%f")
    return timedelta(
        hours=dt.hour, minutes=dt.minute, seconds=dt.second, microseconds=dt.microsecond
    )


def format_timestamp(td):
    """Format timedelta back to SRT timestamp format"""
    total_seconds = int(td.total_seconds())
    hours = total_seconds // 3600
    minutes = (total_seconds % 3600) // 60
    seconds = total_seconds % 60
    milliseconds = td.microseconds // 1000
    return f"{hours:02d}:{minutes:02d}:{seconds:02d},{milliseconds:03d}"


def read_srt_file(path: Path) -> str:
    """Read an SRT file trying common subtitle encodings."""
    encodings_to_try = ["utf-8-sig", "cp1252", "latin-1"]
    for enc in encodings_to_try:
        try:
            return path.read_text(encoding=enc)
        except UnicodeDecodeError:
            continue
    # Last resort: read as utf-8 and replace unreadable characters
    return path.read_text(encoding="utf-8", errors="replace")


def offset_srt(input_file, output_file, offset_seconds):
    """Offset all timestamps in an SRT file"""
    offset = timedelta(seconds=offset_seconds)

    input_path = Path(input_file) if not isinstance(input_file, Path) else input_file
    output_path = (
        Path(output_file) if not isinstance(output_file, Path) else output_file
    )

    content = read_srt_file(input_path)

    # Regex pattern to match SRT timestamp lines
    timestamp_pattern = r"(\d{2}:\d{2}:\d{2},\d{3}) --> (\d{2}:\d{2}:\d{2},\d{3})"

    def replace_timestamp(match):
        start_ts = match.group(1)
        end_ts = match.group(2)
        start_td = parse_timestamp(start_ts)
        end_td = parse_timestamp(end_ts)
        new_start = start_td + offset
        new_end = end_td + offset
        if new_start.total_seconds() < 0:
            new_start = timedelta(0)
        if new_end.total_seconds() < 0:
            new_end = timedelta(0)
        return f"{format_timestamp(new_start)} --> {format_timestamp(new_end)}"

    modified_content = re.sub(timestamp_pattern, replace_timestamp, content)

    output_path.write_text(modified_content, encoding="utf-8")


# Prompt user for input
print("SRT Timestamp Offset Tool")
print("=" * 40)

if len(sys.argv) > 1:
    input_file_str = sys.argv[1]
else:
    input_file_str = input("Enter the path to your .srt file: ").strip().strip("\"'")

input_path = Path(input_file_str)

if not input_path.exists():
    print(f"Error: File '{input_path}' not found!")
    sys.exit(1)

while True:
    try:
        offset_seconds = float(
            input(
                "Enter offset in seconds (negative to make earlier, positive to make later): "
            )
        )
        break
    except ValueError:
        print("Please enter a valid number!")

# Generate output filename with timestamp suffix
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
output_path = (
    input_path.parent / f"{input_path.stem}_offset_{timestamp}{input_path.suffix}"
)

offset_srt(input_path, output_path, offset_seconds)

print("\n" + "=" * 40)
print(f"Successfully offset timestamps by {offset_seconds} second(s)!")
print(f"Output saved to: {output_path}")
