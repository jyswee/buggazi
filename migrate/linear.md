# Migrate from Linear

> **Supported:** Linear's current **GraphQL** API (`api.linear.app/graphql`).

## 1. Get a token

Create a personal API key at [linear.app/settings/api](https://linear.app/settings/api). You'll also need your team key (e.g. `ENG`).

## 2. Preview (writes nothing)

```bash
bgz migrate linear \
  --token YOUR_LINEAR_KEY \
  --team ENG \
  --dry-run
```

Issues labelled `bug` (or in a triage state) import as bugs; everything else imports as features.

## 3. Import for real

Drop `--dry-run`:

```bash
bgz migrate linear --token YOUR_LINEAR_KEY --team ENG
```

The live-API import is full fidelity. Each item keeps its **comments** (with author), original Linear link + identifier, **assignee**, **estimate / created / updated / due dates / creator** (into `metadata`), its **cycle** (created and linked as a sprint), and typed **links** (parent → child-of, sub-issues → parent-of, relations → blocks/duplicates/relates). Linear attachments are integration/URL references, so they import as **external links** rather than mirrored files.

## No token? Import from a CSV export

Can't create an API key? Export instead: **Workspace settings → Import / Export → Export CSV**, then point the importer at the file with `--file`. It parses locally and maps every field the export contains — no credentials needed.

```bash
bgz migrate linear --file linear-export.csv --team ENG --dry-run   # preview
bgz migrate linear --file linear-export.csv --team ENG             # import
```

Columns read: Title, Description, Priority, Status, Labels, Assignee, ID, plus Estimate / Creator / Created / Updated / Due date when present. A CSV export does **not** contain comments, attachments, or cross-item links, so the `--file` path cannot import those — use the live API above if you need them. A sample lives at [`examples/linear-export.csv`](./examples/linear-export.csv).

## Flags

| Flag | Effect |
|------|--------|
| `--file export.csv` | Import from a CSV export instead of the live API — no token needed |
| `--status open` / `--status closed` | Filter by state |
| `--bugs-only` / `--features-only` | Import one kind |
| `--limit N` | Cap the number imported |
| `--dry-run` | Preview only |

Want to see the result without a Linear account first? Run the [demo](./demo.sh): `./demo.sh linear`.
