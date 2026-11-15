#!/usr/bin/env python3

import json
import os
import subprocess
import sys
from pathlib import Path

ENGLISH = {"eng", "en", "english"}


def clean_path(raw: str) -> Path:
    """Tidy up a typed, pasted, or drag-and-dropped path."""
    text = raw.strip()
    # Remove surrounding quotes, e.g. "My Movie.mp4" or 'My Movie.mp4'
    if len(text) >= 2 and text[0] == text[-1] and text[0] in "\"'":
        text = text[1:-1]
    # Undo backslash-escaped spaces from drag-and-drop (not on Windows,
    # where backslash is the path separator)
    if os.name != "nt":
        text = text.replace("\\ ", " ")
    return Path(text).expanduser()


def get_source_path() -> Path:
    if len(sys.argv) > 2:
        print(f"Usage: {sys.argv[0]} [movie_file]", file=sys.stderr)
        sys.exit(1)

    if len(sys.argv) == 2:
        return clean_path(sys.argv[1])

    # No argument: prompt until a real file is given
    while True:
        try:
            raw = input("Path to movie file: ")
        except (EOFError, KeyboardInterrupt):
            print()
            sys.exit("Cancelled.")
        if not raw.strip():
            continue
        path = clean_path(raw)
        if path.is_file():
            return path
        print(f"File not found: {path}. Try again (Ctrl+C to quit).")


def subtitle_streams(path: Path) -> list[dict]:
    probe = subprocess.run(
        [
            "ffprobe",
            "-v",
            "error",
            "-select_streams",
            "s",
            "-show_entries",
            "stream=index,codec_name:stream_tags=language",
            "-of",
            "json",
            str(path),
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(probe.stdout or "{}").get("streams", [])


def english_stream_id(streams: list[dict]) -> int | None:
    for stream in streams:
        lang = (stream.get("tags") or {}).get("language", "").lower()
        if lang in ENGLISH:
            return stream["index"]
    return None


def main() -> None:
    src = get_source_path()
    if not src.is_file():
        sys.exit(f"Error: file not found: {src}")

    streams = subtitle_streams(src)
    if not streams:
        sys.exit("No subtitle streams found.")

    stream_id = english_stream_id(streams)
    if stream_id is None:
        print("No English subtitle stream found. Available:", file=sys.stderr)
        for stream in streams:
            lang = (stream.get("tags") or {}).get("language", "?")
            print(
                f"  {stream['index']}: {stream.get('codec_name', '?')} ({lang})",
                file=sys.stderr,
            )
        sys.exit(1)

    # MyMovie.mp4 -> MyMovie.srt (same folder)
    out = src.with_suffix(".srt")
    print(f"Found English subtitle at stream 0:{stream_id}")
    print(f"Extracting to: {out}")

    subprocess.run(
        [
            "ffmpeg",
            "-v",
            "error",
            "-stats",
            "-i",
            str(src),
            "-map",
            f"0:{stream_id}",
            "-c:s",
            "srt",
            str(out),
            "-y",
        ],
        check=True,
    )
    print("Done!")


if __name__ == "__main__":
    main()
