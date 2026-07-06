# bgz

[![npm version](https://img.shields.io/npm/v/buggazi.svg)](https://www.npmjs.com/package/buggazi)

Project management for coding agents. Bug tracking, feature planning, sprint management - as easy as git.

## Install

```bash
npm install -g buggazi
```

The npm package is `buggazi`; the command is `bgz`.

## Quick Start

```bash
# Create a project
bgz signup my-project --local

# File a bug
bgz bug "Login form returns 500" -s P1

# Plan a feature
bgz feature "SSO support" -p P1

# See your project
bgz snapshot

# Resolve a bug
bgz fix BUG-2026-0608-001 -c a3f2c1d -f "Added null check"

# Full reference
bgz --help
```

## Cross-Tenant Contracts

File bugs and features directly into a partner project over a contract — agent to agent.

```bash
# File a bug to a partner, with a visual repro attached
bgz contract CTR-ID file-bug "Checkout 500s on submit" -s P1 --screenshot ./crash.png

# Bump severity after filing — no delete + re-file
bgz contract CTR-ID update-bug BUG-ID -s P0
```

Screenshots upload via a presigned S3 URL and are served from the CDN. External contract filings require human approval on the receiving side (EU AI Act compliant).

## MCP Server

Prefer tools over a CLI? `bgz` ships an MCP server — point Claude Code (or any MCP client) at it and your agent gets bugs, features, sprints and contracts as native tools.

```bash
claude mcp add buggazi -- bgz mcp-serve
```

## Webhooks — close the loop

Get notified when things change instead of polling. Agent A files a bug, the fix ships, the webhook fires, Agent A retries — no human in the middle.

```bash
bgz settings webhooks set --url https://your-stack.example/hooks --events "bug:resolved"
bgz notifications          # or pull: what changed recently
```

Payloads are HMAC-SHA256 signed (`X-Buggazi-Signature`).

## Features

- **Bugs** - file, track, resolve with evidence and screenshots
- **Features** - plan, prioritize, link to bugs, dependency trees
- **Sprints** - create, track progress, kanban board
- **Contracts** - cross-tenant bug/feature filing between projects, with screenshot attachments
- **Snapshots** - terminal project views, shareable HTML links
- **Webhooks & notifications** - signed HTTP callbacks + `bgz notifications` for polling
- **MCP server** - native tool access for Claude Code and other MCP clients
- **Audit trail** - EU AI Act compliant, immutable event log

## Per-Project Config

```bash
bgz login --local --key YOUR_KEY    # saves to .bgz/config.json (project-local)
bgz config                          # show active config
```

Config is per-project and auto-loaded from `.bgz/config.json`. Add `.bgz/` to your `.gitignore`.

## Agent Integration

Add to your CLAUDE.md, .cursorrules, .clinerules, .windsurfrules, or AGENTS.md:

```
## Buggazi
This project uses Buggazi for bug tracking and feature planning.
Use the `bgz` CLI. Config is in .bgz/config.json (auto-loaded).
If not configured: bgz login --local --key YOUR_KEY

Run `bgz init --agent-schema` — it returns every command + valid flags.
This is the single source of truth: if it is not in the schema, do not use it.
```

## Documentation

- [Quickstart Guides](https://buggazi.com/docs/quickstart.html)
- [Full Reference](https://buggazi.com/llms.txt)

## License

Proprietary - Tyga.Cloud Ltd. See [LICENSE](./LICENSE).
