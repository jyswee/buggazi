# Migrate from Shortcut

> **Supported:** Shortcut REST API **v3** (`/api/v3`).

## 1. Get a token

Create an API token at [app.shortcut.com/settings/account/api-tokens](https://app.shortcut.com/settings/account/api-tokens). You'll also need your project name.

## 2. Preview (writes nothing)

```bash
bgz migrate shortcut \
  --token YOUR_SHORTCUT_TOKEN \
  --project "My Project" \
  --dry-run
```

Stories of type `bug` import as bugs; everything else imports as features.

## 3. Import for real

Drop `--dry-run`:

```bash
bgz migrate shortcut --token YOUR_SHORTCUT_TOKEN --project "My Project"
```

The live-API import is full fidelity. Each item keeps its **comments** (with author, resolved from member names), original Shortcut link + story ID, **owner → assignee** and **requester → reporter**, **estimate / created / updated / deadline / epic** (into `metadata`), its **iteration** (created and linked as a sprint), typed **links** (story links → blocks/duplicates/relates), and **file attachments** (downloaded and mirrored to your storage).

## No token? Import from a CSV export

Can't create an API token? Export instead: **Stories view → ⋯ → Export CSV**, then point the importer at the file with `--file`. It parses locally and maps every field the export contains — no credentials needed.

```bash
bgz migrate shortcut --file shortcut-export.csv --project "My Project" --dry-run   # preview
bgz migrate shortcut --file shortcut-export.csv --project "My Project"             # import
```

Columns read: Name, Description, Type, State, Estimate, Labels, ID, Owners, plus Requester / Created / Updated / Deadline / Epic when present. A CSV export does **not** contain comments, attachments, or cross-item links, so the `--file` path cannot import those — use the live API above if you need them. A sample lives at [`examples/shortcut-export.csv`](./examples/shortcut-export.csv).

## Flags

| Flag | Effect |
|------|--------|
| `--file export.csv` | Import from a CSV export instead of the live API — no token needed |
| `--bugs-only` / `--features-only` | Import one kind |
| `--limit N` | Cap the number imported |
| `--dry-run` | Preview only |

Want to see the result without a Shortcut account first? Run the [demo](./demo.sh): `./demo.sh shortcut`.
