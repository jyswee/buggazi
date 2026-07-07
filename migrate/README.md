# Migrate to Buggazi

Bring your existing issues into Buggazi with one command. Import is **live today** for three trackers:

| Source | Command | Guide |
|--------|---------|-------|
| Jira | `bgz migrate jira` | [jira.md](./jira.md) |
| Linear | `bgz migrate linear` | [linear.md](./linear.md) |
| Shortcut | `bgz migrate shortcut` | [shortcut.md](./shortcut.md) |

## Preview first — nothing is written until you say so

Every importer supports `--dry-run`. It fetches your issues, maps them to Buggazi bugs and features, and prints exactly what *would* be created — without touching your project.

```bash
bgz migrate jira --from https://myco.atlassian.net --email me@co.com --token TOKEN --project PROJ --dry-run
```

Run the same command without `--dry-run` to import for real.

## See it work in 30 seconds — no account needed

Don't have a Jira/Linear/Shortcut token handy? Replay a sample export into your project through the CLI:

```bash
./demo.sh jira      # or: linear · shortcut
```

It reads [`examples/`](./examples), maps each issue exactly like the real importer, and files them with `bgz bug` / `bgz feature`. Then run `bgz snapshot` to see the result.

## How the mapping works

Every source resolves to the same thing: bugs and features with the right severity. Full table in [mapping.md](./mapping.md). In short — issues typed as bug/defect/error/incident become **bugs**, everything else a **feature**, and priority maps to `P0–P3`. Comments, a link back to the original issue, and the source key are all preserved.

## What's in this folder

| File | What it's for |
|------|---------------|
| [`jira.md`](./jira.md) · [`linear.md`](./linear.md) · [`shortcut.md`](./shortcut.md) | Per-source setup + commands |
| [`mapping.md`](./mapping.md) | Exact type/priority mapping for all three sources |
| [`demo.sh`](./demo.sh) | Replay a sample export through the CLI |
| [`examples/`](./examples) | Real-shape export dumps for Jira, Linear, Shortcut |

## Flags shared by every source

| Flag | Effect |
|------|--------|
| `--dry-run` | Preview only — import nothing |
| `--bugs-only` | Import only issues that map to bugs |
| `--features-only` | Import only issues that map to features |
| `--limit N` | Cap the number of issues imported |

## Before you start

1. Install and sign in: `npm install -g buggazi` then `bgz login --local --key YOUR_KEY`
2. Grab an API token for your source (see each guide).
3. Run with `--dry-run`, eyeball the preview, then run for real.

> Coming from GitHub or GitLab instead? Those are your **source of truth for code** — keep them. `bgz` runs *alongside* your repo as the agent-run PM layer. See the main [README](../README.md#works-alongside-github--gitlab).
