import os
import re
from datetime import datetime, timedelta


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


def offset_srt(input_file, output_file, offset_seconds):
    """Offset all timestamps in an SRT file"""
    offset = timedelta(seconds=offset_seconds)

    with open(input_file, "r", encoding="utf-8-sig") as f:
        content = f.read()

    # Regex pattern to match SRT timestamp lines
    timestamp_pattern = r"(\d{2}:\d{2}:\d{2},\d{3}) --> (\d{2}:\d{2}:\d{2},\d{3})"

    def replace_timestamp(match):
        start_ts = match.group(1)
        end_ts = match.group(2)

        # Parse timestamps
        start_td = parse_timestamp(start_ts)
        end_td = parse_timestamp(end_ts)

        # Apply offset
        new_start = start_td + offset
        new_end = end_td + offset

        # Handle negative timestamps (set to 00:00:00,000)
        if new_start.total_seconds() < 0:
            new_start = timedelta(0)
        if new_end.total_seconds() < 0:
            new_end = timedelta(0)

        # Format back to string
        return f"{format_timestamp(new_start)} --> {format_timestamp(new_end)}"

    # Replace all timestamps
    modified_content = re.sub(timestamp_pattern, replace_timestamp, content)

    # Write to output file
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(modified_content)


# Prompt user for input
print("SRT Timestamp Offset Tool")
print("=" * 40)

input_file = input("Enter the path to your .srt file: ").strip()

# Check if file exists
if not os.path.exists(input_file):
    print(f"Error: File '{input_file}' not found!")
    exit(1)

# Get offset amount
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

# Generate output filename
base_name = os.path.splitext(input_file)[0]
output_file = f"{base_name}_offset.srt"

# Run the offset
offset_srt(input_file, output_file, offset_seconds)

print("\n" + "=" * 40)
print(f"Successfully offset timestamps by {offset_seconds} second(s)!")
print(f"Output saved to: {output_file}")
