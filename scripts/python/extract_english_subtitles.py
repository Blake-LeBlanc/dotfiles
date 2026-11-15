#!/usr/bin/env python3
# claude-opus-5.5

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

# #!/usr/bin/env python3
# # grok-4.7-xhigh
#
# import argparse
# import json
# import subprocess
# from pathlib import Path
#
#
# IMAGE_CODECS = {
#     "hdmv_pgs_subtitle",
#     "dvd_subtitle",
#     "dvb_subtitle",
#     "xsub",
# }
#
#
# def run(command, **kwargs):
#     try:
#         return subprocess.run(command, check=True, **kwargs)
#     except FileNotFoundError:
#         raise SystemExit(f"Required program not found: {command[0]}")
#     except subprocess.CalledProcessError as exc:
#         raise SystemExit(
#             exc.stderr or f"{command[0]} failed with exit code {exc.returncode}."
#         )
#
#
# def is_english(stream):
#     language = stream.get("tags", {}).get("language", "")
#     language = language.lower().replace("_", "-")
#     return language.split("-", 1)[0] in {"eng", "en"}
#
#
# def preference(stream):
#     disposition = stream.get("disposition", {})
#     return (
#         stream.get("codec_name") in IMAGE_CODECS,  # Prefer text subtitles.
#         disposition.get("forced", 0),  # Prefer non-forced tracks.
#         -disposition.get("default", 0),  # Then prefer default tracks.
#         stream["index"],  # Finally, lowest index.
#     )
#
#
# def movie_path_from_prompt():
#     entered = input("Movie file path: ").strip()
#     if len(entered) >= 2 and entered[0] == entered[-1] and entered[0] in {"'", '"'}:
#         entered = entered[1:-1].strip()
#     if not entered:
#         raise SystemExit("No movie file provided.")
#     return Path(entered)
#
#
# parser = argparse.ArgumentParser(
#     description="Extract an English subtitle stream as SRT."
# )
# parser.add_argument(
#     "movie",
#     nargs="?",
#     type=Path,
#     help="Movie file. If omitted, you will be prompted for the path.",
# )
# parser.add_argument(
#     "-o",
#     "--output",
#     type=Path,
#     help="Output filename; defaults to the movie filename with .srt extension.",
# )
# parser.add_argument(
#     "--stream",
#     type=int,
#     help="Choose an absolute subtitle stream index instead of auto-selecting.",
# )
# parser.add_argument(
#     "--overwrite",
#     action="store_true",
#     help="Allow overwriting an existing output file.",
# )
# args = parser.parse_args()
#
# source = (args.movie or movie_path_from_prompt()).expanduser().resolve()
# output = (args.output or source.with_suffix(".srt")).expanduser().resolve()
#
# if not source.is_file():
#     raise SystemExit(f"Movie file not found: {source}")
# if source == output:
#     raise SystemExit("Input and output must be different files.")
#
# probe = run(
#     [
#         "ffprobe",
#         "-v",
#         "error",
#         "-select_streams",
#         "s",
#         "-show_streams",
#         "-of",
#         "json",
#         str(source),
#     ],
#     capture_output=True,
#     text=True,
# )
# streams = json.loads(probe.stdout).get("streams", [])
#
# if args.stream is not None:
#     candidates = [s for s in streams if s["index"] == args.stream]
# else:
#     candidates = [s for s in streams if is_english(s)]
#
# if not candidates:
#     raise SystemExit(
#         "No matching subtitle stream found. "
#         "If language tags are missing, use --stream INDEX."
#     )
#
# selected = min(candidates, key=preference)
# index = selected["index"]
# codec = selected.get("codec_name", "unknown")
#
# if codec in IMAGE_CODECS:
#     raise SystemExit(
#         f"Stream 0:{index} uses image-based subtitles ({codec}). "
#         "Converting these to SRT requires OCR."
#     )
#
# print(f"Extracting stream 0:{index} ({codec}) -> {output}", flush=True)
#
# run(
#     [
#         "ffmpeg",
#         "-hide_banner",
#         "-loglevel",
#         "error",
#         "-nostdin",
#         "-y" if args.overwrite else "-n",
#         "-i",
#         str(source),
#         "-map",
#         f"0:{index}",
#         "-c:s",
#         "srt",
#         "-f",
#         "srt",
#         str(output),
#     ]
# )
