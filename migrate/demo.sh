#!/usr/bin/env bash
#
# demo.sh — watch a REAL migration land in your bgz project in ~30 seconds,
# WITHOUT needing a Jira / Linear / Shortcut account.
#
# It runs the real importer against a bundled CSV export
# (./examples/<source>-export.csv) via `bgz migrate <source> --file` — the exact
# same no-token path you'd use on your own export. First a `--dry-run` preview
# (nothing is written), then — on your OK — the real import.
#
# A live migration is one command straight from your tracker's API:
#
#     bgz migrate jira     --from URL --email EMAIL --token TOKEN --project PROJ
#     bgz migrate linear   --token KEY --team ENG
#     bgz migrate shortcut --token TOKEN --project "My Project"
#
# …or point --file at your own CSV export — no token needed.
#
# Usage:  ./demo.sh [jira|linear|shortcut] [--yes]
# Needs:  bgz (npm install -g buggazi) + logged in (bgz login).

set -euo pipefail

SOURCE="${1:-jira}"
YES=0
for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done

case "$SOURCE" in
  jira|linear|shortcut) ;;
  *) echo "Usage: ./demo.sh [jira|linear|shortcut] [--yes]"; exit 1 ;;
esac

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$DIR/examples/${SOURCE}-export.csv"

command -v bgz >/dev/null 2>&1 || { echo "bgz not found — install with: npm install -g buggazi"; exit 1; }
[ -f "$FILE" ] || { echo "Missing sample export: $FILE"; exit 1; }

# Optional scope label — carried through file mode for realism (not required).
case "$SOURCE" in
  jira)     SCOPE=(--project DEMO) ;;
  linear)   SCOPE=(--team ENG) ;;
  shortcut) SCOPE=(--project "Demo Project") ;;
esac

echo "▶ Preview — parsing ${SOURCE}-export.csv (nothing is written yet):"
echo
bgz migrate "$SOURCE" --file "$FILE" "${SCOPE[@]}" --dry-run
echo

if [ "$YES" -ne 1 ]; then
  read -r -p "Import these into your ACTIVE bgz project now? [y/N] " ans
  case "$ans" in y|Y) ;; *) echo "Aborted — nothing created."; exit 0 ;; esac
fi

echo
echo "▶ Importing for real:"
bgz migrate "$SOURCE" --file "$FILE" "${SCOPE[@]}"
echo
echo "Done. See the whole project:"
echo "  bgz snapshot"
