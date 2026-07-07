#!/usr/bin/env bash
#
# demo.sh — watch a migration land in your bgz project in ~30 seconds,
# WITHOUT needing a Jira / Linear / Shortcut account.
#
# It replays a sample export (./examples/<source>-export.json) through the
# real `bgz` CLI, using the same bug/feature mapping the importer uses.
#
# This is a *see-the-result* demo. A real migration is one command and reads
# straight from your tracker's live API — no script, no dump file:
#
#     bgz migrate jira     --from URL --email EMAIL --token TOKEN --project PROJ
#     bgz migrate linear   --token KEY --team ENG
#     bgz migrate shortcut --token TOKEN --project "My Project"
#
# Usage:  ./demo.sh [jira|linear|shortcut] [--yes]
# Needs:  bgz (npm install -g buggazi) + logged in, and jq.

set -euo pipefail

SOURCE="${1:-jira}"
YES=0
for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$DIR/examples/${SOURCE}-export.json"

case "$SOURCE" in
  jira|linear|shortcut) ;;
  *) echo "Usage: ./demo.sh [jira|linear|shortcut] [--yes]"; exit 1 ;;
esac
command -v bgz >/dev/null 2>&1 || { echo "bgz not found — install with: npm install -g buggazi"; exit 1; }
command -v jq  >/dev/null 2>&1 || { echo "jq not found — install jq to run this demo."; exit 1; }
[ -f "$FILE" ] || { echo "Missing sample dump: $FILE"; exit 1; }

# ── Map the source's raw export to: kind <TAB> level <TAB> title <TAB> description ──
case "$SOURCE" in
  jira)
    rows="$(jq -r '
      def kind(t): (t|ascii_downcase) as $t
        | if $t=="bug" or $t=="defect" or $t=="error" or $t=="incident" then "bug" else "feature" end;
      def level(p): (p|ascii_downcase) as $p
        | if   $p=="highest" or $p=="critical" or $p=="urgent" then "P0"
          elif $p=="high"                                       then "P1"
          elif $p=="medium" or $p=="normal"                     then "P2"
          else "P3" end;
      .issues[] | [ kind(.fields.issuetype.name), level(.fields.priority.name), .fields.summary, (.fields.description // "") ] | @tsv
    ' "$FILE")"
    ;;
  linear)
    rows="$(jq -r '
      def level(p): if p==1 then "P0" elif p==2 then "P1" elif p==3 then "P2" else "P3" end;
      .data.team.issues.nodes[]
      | ( [ .labels.nodes[].name | ascii_downcase ] | index("bug") ) as $isbug
      | [ (if $isbug != null then "bug" else "feature" end), level(.priority), .title, (.description // "") ] | @tsv
    ' "$FILE")"
    ;;
  shortcut)
    rows="$(jq -r '
      def level(e): if e==null then "P2" elif e>=8 then "P0" elif e>=5 then "P1" elif e>=2 then "P2" else "P3" end;
      .data[] | [ (if .story_type=="bug" then "bug" else "feature" end), level(.estimate), .name, (.description // "") ] | @tsv
    ' "$FILE")"
    ;;
esac

echo "Replaying $(printf '%s\n' "$rows" | grep -c .) items from ${SOURCE}-export.json into your ACTIVE bgz project:"
echo
bgz config 2>/dev/null || true
echo
if [ "$YES" -ne 1 ]; then
  read -r -p "Create these demo items now? [y/N] " ans
  case "$ans" in y|Y) ;; *) echo "Aborted — nothing created."; exit 0 ;; esac
fi

# ── Replay through the CLI ──
while IFS=$'\t' read -r kind level title desc; do
  [ -z "$title" ] && continue
  if [ "$kind" = "bug" ]; then
    bgz bug "$title" -s "$level" -d "$desc" --source "${SOURCE}-demo"
  else
    bgz feature "$title" -p "$level" -d "$desc"
  fi
done <<< "$rows"

echo
echo "Done. See the whole project:"
echo "  bgz snapshot"
