# Mapping reference

Exactly how each source's issues become Buggazi bugs and features. This mirrors the importer — no surprises after you run it.

## Supported source versions

| Source | API we support | Not supported |
|--------|----------------|---------------|
| Jira | **Cloud** REST API **v3** (`/rest/api/3`) | Jira **Server / Data Center** (v2 API) |
| Linear | current **GraphQL** API (`api.linear.app/graphql`) | — |
| Shortcut | REST API **v3** (`/api/v3`) | — |

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

## What's carried over — by path

Coverage depends on **which path** you use. The **live API** (with a token) is full fidelity. The **CSV export** (`--file`, no token) carries only what a CSV export physically contains — comments, attachments, and cross-item links are never in a CSV, so they can't be imported that way.

| Field | Live API | CSV (`--file`) |
|-------|:--------:|:--------------:|
| Title, description | ✅ | ✅ |
| Priority / severity | ✅ | ✅ |
| Status | ✅ | ✅ |
| Labels → category / tags | ✅ | ✅ |
| Assignee | ✅ | ✅ (when column present) |
| Backlink + source key | ✅ | ✅ |
| Story points | ✅ | ✅ (when column present) |
| Created / updated / due dates | ✅ | ✅ (when columns present) |
| Reporter | ✅ | ✅ (when column present) |
| **Comments** (with author) | ✅ | ❌ not in a CSV export |
| **Sprints / cycles / iterations** | ✅ created + linked | ❌ not in a CSV export |
| **Typed links** (epic/subtask/blocks/duplicates/relates) | ✅ | ❌ not in a CSV export |
| **Attachments** | ✅ mirrored to your storage¹ | ❌ not in a CSV export |
| Provenance (`source`, `agent`) | ✅ | ✅ |

¹ Jira and Shortcut attachments are downloaded and mirrored to your storage. **Linear** attachments are integration/URL references (not file blobs), so they import as **external links** rather than mirrored files.

Non-core fields (story points, dates, reporter, epic id) are preserved into each item's `metadata`, so nothing is lost even where Buggazi has no first-class field for it.

## Filtering an import

- `--bugs-only` / `--features-only` — bring across one kind.
- `--limit N` — cap how many issues are pulled.
- `--dry-run` — preview the full mapping without writing anything.
