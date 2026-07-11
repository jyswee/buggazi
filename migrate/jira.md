# Migrate from Jira

> **Supported:** Jira **Cloud**, REST API **v3** (`/rest/api/3`). Jira **Server / Data Center** (v2 API) is **not** supported for live-API import — export to CSV and use `--file` instead.

## 1. Get a token

Create an API token at [id.atlassian.com](https://id.atlassian.com/manage-profile/security/api-tokens). You'll also need the email you log into Jira with and your project key (e.g. `PROJ`).

## 2. Preview (writes nothing)

```bash
bgz migrate jira \
  --from https://myco.atlassian.net \
  --email me@co.com \
  --token YOUR_JIRA_TOKEN \
  --project PROJ \
  --dry-run
```

You'll see every issue that would import, split into bugs and features.

## 3. Import for real

Drop `--dry-run`:

```bash
bgz migrate jira --from https://myco.atlassian.net --email me@co.com --token YOUR_JIRA_TOKEN --project PROJ
```

The live-API import is full fidelity. Each item keeps its **comments** (with author), original Jira link + issue key, **assignee**, **story points / created / updated / due dates / reporter** (into `metadata`), its **sprint** (created and linked), typed **links** (parent → child-of, subtasks → parent-of, issue links → blocks/duplicates/relates), and **attachments** (downloaded and mirrored to your storage).

## No token? Import from a CSV export

Can't create an API token — or on Jira Server / Data Center? Export instead: **Filters → Export → Export Excel CSV (all fields)**, then point the importer at the file with `--file`. It parses locally and maps every field the export contains — no credentials needed.

```bash
bgz migrate jira --file jira-export.csv --project PROJ --dry-run   # preview
bgz migrate jira --file jira-export.csv --project PROJ             # import
```

Columns read: Summary, Description, Issue Type, Priority, Status, Labels, Assignee, Issue key, plus Story Points / Reporter / Created / Updated / Due date when present. A CSV export does **not** contain comments, attachments, or cross-item links, so the `--file` path cannot import those — use the live API above if you need them. A sample lives at [`examples/jira-export.csv`](./examples/jira-export.csv).

## Flags

| Flag | Effect |
|------|--------|
| `--file export.csv` | Import from a CSV export instead of the live API — no token needed |
| `--status open` | Only issues not yet Done |
| `--status closed` | Only Done issues |
| `--bugs-only` / `--features-only` | Import one kind |
| `--limit N` | Cap the number imported |
| `--dry-run` | Preview only |

Want to see the result without a Jira account first? Run the [demo](./demo.sh): `./demo.sh jira`.
