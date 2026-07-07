# Migrate from Linear

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

Each item keeps its comments, original Linear link, and identifier.

## Flags

| Flag | Effect |
|------|--------|
| `--status open` / `--status closed` | Filter by state |
| `--bugs-only` / `--features-only` | Import one kind |
| `--limit N` | Cap the number imported |
| `--dry-run` | Preview only |

Want to see the result without a Linear account first? Run the [demo](./demo.sh): `./demo.sh linear`.
