# Migrate from Shortcut

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

Each item keeps its comments, original Shortcut link, and story ID.

## Flags

| Flag | Effect |
|------|--------|
| `--bugs-only` / `--features-only` | Import one kind |
| `--limit N` | Cap the number imported |
| `--dry-run` | Preview only |

Want to see the result without a Shortcut account first? Run the [demo](./demo.sh): `./demo.sh shortcut`.
