# Mapping reference

Exactly how each source's issues become Buggazi bugs and features. This mirrors the importer — no surprises after you run it.

## Bug vs. feature

| Source | Treated as a **bug** when… |
|--------|-----------------------------|
| Jira | issue type is `Bug`, `Defect`, `Error`, or `Incident` |
| Linear | it has a `Bug` label, or its state type is `triage` |
| Shortcut | `story_type` is `bug` |

Everything else becomes a **feature**.

## Priority / severity

**Jira** — from the issue's priority name:

| Jira priority | Buggazi |
|---------------|---------|
| Highest / Critical / Urgent | P0 |
| High | P1 |
| Medium / Normal | P2 |
| Low / Lowest / Trivial | P3 |
| (none) | P2 |

**Linear** — from the numeric priority:

| Linear | Buggazi |
|--------|---------|
| 1 (Urgent) | P0 |
| 2 (High) | P1 |
| 3 (Medium) | P2 |
| 0 (None) / 4 (Low) | P3 |

**Shortcut** — inferred from the story estimate (Shortcut has no priority field):

| Estimate | Buggazi |
|----------|---------|
| ≥ 8 | P0 |
| ≥ 5 | P1 |
| ≥ 2 | P2 |
| < 2 | P3 |
| (none) | P2 |

## What's carried over

Each imported item keeps:

- **Comments** — re-attached, tagged with the original author and source key.
- **A link back** to the source issue (`externalLinks`), so the trail is never lost.
- **The source key** — `SHOP-412`, `ENG-142`, `sc-412` — for cross-referencing.
- **Provenance** — `source: "<tool>-migration"` and `agent: "bgz-migrate"`, so you can always tell what came from where.

## Filtering an import

- `--bugs-only` / `--features-only` — bring across one kind.
- `--limit N` — cap how many issues are pulled.
- `--dry-run` — preview the full mapping without writing anything.
