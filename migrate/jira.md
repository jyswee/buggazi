# Migrate from Jira

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

Each item keeps its comments, original Jira link, and issue key.

## Flags

| Flag | Effect |
|------|--------|
| `--status open` | Only issues not yet Done |
| `--status closed` | Only Done issues |
| `--bugs-only` / `--features-only` | Import one kind |
| `--limit N` | Cap the number imported |
| `--dry-run` | Preview only |

Want to see the result without a Jira account first? Run the [demo](./demo.sh): `./demo.sh jira`.
