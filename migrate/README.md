# Migrate to Buggazi

Bring your existing issues into Buggazi with one command. Import is **live today** for three trackers — via the live API, or from a CSV export dump with **no API token**:

| Source | Live API | From a CSV export | Guide |
|--------|----------|-------------------|-------|
| Jira | `bgz migrate jira` | `bgz migrate jira --file jira-export.csv` | [jira.md](./jira.md) |
| Linear | `bgz migrate linear` | `bgz migrate linear --file linear-export.csv` | [linear.md](./linear.md) |
| Shortcut | `bgz migrate shortcut` | `bgz migrate shortcut --file shortcut-export.csv` | [shortcut.md](./shortcut.md) |

## Supported source versions

| Source | API we support | Not supported |
|--------|----------------|---------------|
| Jira | **Cloud** REST API **v3** (`/rest/api/3`) | Jira **Server / Data Center** (v2 API) |
| Linear | current **GraphQL** API (`api.linear.app/graphql`) | — |
| Shortcut | REST API **v3** (`/api/v3`) | — |

The **CSV export** path works for any of the three regardless of hosting — it reads whatever your export contains.

## Preview first — nothing is written until you say so

Every importer supports `--dry-run`. It fetches (or parses) your issues, maps them to Buggazi bugs and features, and prints exactly what *would* be created — without touching your project.

```bash
bgz migrate jira --from https://myco.atlassian.net --email me@co.com --token TOKEN --project PROJ --dry-run
```

Run the same command without `--dry-run` to import for real.

## No API token? Import from a CSV export dump

Don't have (or can't get) an API token? Export your issues to CSV from the source tool and point any importer at the file with `--file`. It parses the export locally, maps every field the export contains, and imports — no credentials needed.

**What the CSV path can and can't carry:** it imports every field present in the export — title, description, priority/severity, status, labels, assignee, backlink + source key, and story points / dates when those columns exist. But a CSV export does **not** contain comments, attachments, or cross-item links, so the `--file` path cannot import those. Need comments, attachments, sprints, and typed links? Use the **live API** path (with a token) — see below.

```bash
# Export from the source, then:
bgz migrate jira     --file jira-export.csv     --project PROJ --dry-run
bgz migrate linear   --file linear-export.csv   --team ENG     --dry-run
bgz migrate shortcut --file shortcut-export.csv --project "My Project" --dry-run
```

Drop `--dry-run` to import for real. Where to get the export:

| Source | Export path |
|--------|-------------|
| Jira | **Filters → Export → Export Excel CSV (all fields)** |
| Linear | **Workspace settings → Import / Export → Export CSV** |
| Shortcut | **Stories view → ⋯ → Export CSV** |

Sample exports in the exact shape each importer expects live in [`examples/`](./examples) — `jira-export.csv`, `linear-export.csv`, `shortcut-export.csv`.

## See it work in 30 seconds — no account needed

Replay a sample export into your project through the CLI:

```bash
./demo.sh jira      # or: linear · shortcut
```

It reads [`examples/`](./examples), maps each issue with the same field mapping the real importer uses, and files them. Then run `bgz snapshot` to see the result.

## How the mapping works

Every source resolves to the same thing: bugs and features with the right severity. Full per-field, per-source, per-path table in [mapping.md](./mapping.md). In short — issues typed as bug/defect/error/incident become **bugs**, everything else a **feature**, and priority maps to `P0–P3`. A link back to the original issue and the source key are always preserved.

**Live API vs CSV — coverage differs:**

- **Live API (token):** full fidelity — comments (with author), sprints/cycles/iterations, story points + created/updated/due dates + reporter, typed links (epics/subtasks/blocks/duplicates/relates), and attachments mirrored to your storage. Linear attachments are URL references and import as external links.
- **CSV (`--file`):** everything the export contains (incl. story points/dates when present), but **no comments, attachments, or cross-item links** — those aren't in a CSV export.

## What's in this folder

| File | What it's for |
|------|---------------|
| [`jira.md`](./jira.md) · [`linear.md`](./linear.md) · [`shortcut.md`](./shortcut.md) | Per-source setup + commands |
| [`mapping.md`](./mapping.md) | Exact type/priority mapping for all three sources |
| [`demo.sh`](./demo.sh) | Replay a sample export through the CLI |
| [`examples/`](./examples) | Real-shape export dumps (CSV + JSON) for Jira, Linear, Shortcut |

## Flags shared by every source

| Flag | Effect |
|------|--------|
| `--file export.csv` | Import from a CSV export dump instead of the live API — no token needed |
| `--dry-run` | Preview only — import nothing |
| `--bugs-only` | Import only issues that map to bugs |
| `--features-only` | Import only issues that map to features |
| `--limit N` | Cap the number of issues imported |

## Before you start

1. Install and sign in: `npm install -g buggazi` then `bgz login --local --key YOUR_KEY`
2. Either grab an API token for your source (see each guide) **or** export it to CSV — no token needed for `--file`.
3. Run with `--dry-run`, eyeball the preview, then run for real.

> Coming from GitHub or GitLab instead? Those are your **source of truth for code** — keep them. `bgz` runs *alongside* your repo as the agent-run PM layer. See the main [README](../README.md#works-alongside-github--gitlab).
