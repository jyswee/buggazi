# buggazi

> git tracks your code. bgz tracks your project.

Project management for coding agents. Bug tracking, feature planning, sprint management — as easy as git.

## Install

```bash
npm install -g buggazi
```

## Screenshots

**Roadmap board** — plan releases across sprints
![Roadmap board](https://prodmedia.tyga.host/public/tyga.cloud/landing/buggazi.com/dashboard/roadmap-board.png)

**Bugs overview** — file, track, resolve with evidence
![Bugs overview](https://prodmedia.tyga.host/public/tyga.cloud/landing/buggazi.com/dashboard/bugs-overview.png)

**Features board** — kanban planning, priorities, dependency trees
![Features overview](https://prodmedia.tyga.host/public/tyga.cloud/landing/buggazi.com/dashboard/features-overview.png)

**Sprints** — attach features, track computed progress
![Sprints overview](https://prodmedia.tyga.host/public/tyga.cloud/landing/buggazi.com/dashboard/sprints-overview.png)

## Quick Start

```bash
# Create a project ($10/mo Solo plan)
bgz signup my-project --local

# File a bug
bgz bug "Login form returns 500" -s P1

# Plan a feature (optionally attach to a sprint)
bgz feature "SSO support" -p P1 --sprint SPRINT-ID

# Resolve a bug with reasoning
bgz fix BUG-ID -c a3f2c1d -f "Added null check" -r "Root cause was missing validation"

# See your project
bgz snapshot

# Full reference
bgz --help
```

## Cross-Company Contracts

File bugs and features straight into a partner's project over a contract — agent to agent.

```bash
# File a bug to a partner, with a visual repro attached
bgz contract CTR-ID file-bug "Checkout 500s on submit" -s P1 --screenshot ./crash.png

# Bump severity after filing — no delete + re-file
bgz contract CTR-ID update-bug BUG-ID -s P0
```

Screenshots upload via a presigned S3 URL and are served from the CDN. External filings require human approval on the receiving side (EU AI Act compliant).

## Works With

**CLI agents** — `npm install -g buggazi`
- Claude Code, Cursor, Cline, Windsurf, Codex, Copilot, Aider

**Web agents** — no install needed
- Lovable, Bolt.new, Replit, Claude Web, Raycast

## Features

- **Bug Tracking** — file, track, resolve with evidence + reasoning
- **Feature Planning** — kanban board, priorities, bug-feature linking, dependency trees
- **Sprint Management** — create sprints, attach features (`--sprint`), progress computed from linked features
- **Cross-Company Contracts** — file bugs/features in partner projects with screenshot attachments (EU AI Act compliant)
- **Migration** — import from Jira, Linear, Shortcut in 60 seconds
- **Snapshots** — terminal project views, shareable HTML links
- **MCP Server** — 24 native tools for Claude Code (`bgz mcp-serve`)
- **Audit Trail** — immutable event log, CSV export
- **Fail-loud validation** — bad args error clearly instead of creating junk records; covered by unit tests

## Agent Integration

Add to your CLAUDE.md, .cursorrules, .clinerules, or .windsurfrules:

```
## Buggazi
Use the bgz CLI for bug tracking and feature planning.
Run: bgz init --agent-schema (JSON schema of all commands + valid flags)
Key is in .bgz/config.json (auto-loaded).
```

### MCP Server (Claude Code)

Add `.mcp.json` to your project root:

```json
{
  "mcpServers": {
    "buggazi": {
      "type": "stdio",
      "command": "bgz",
      "args": ["mcp-serve"]
    }
  }
}
```

Claude Code discovers 24 Buggazi tools automatically — zero config beyond this file.

### Remote MCP (no install)

For web agents or anywhere you can't install the CLI:

```json
{
  "mcpServers": {
    "buggazi": {
      "type": "sse",
      "url": "https://mcp.buggazi.com/sse",
      "headers": { "Authorization": "Bearer bgz_YOUR_API_KEY" }
    }
  }
}
```

See the [Remote MCP quickstart](https://buggazi.com/docs/quickstart/remote-mcp.html).

## Config

```bash
bgz login --local --key YOUR_KEY    # saves to .bgz/config.json (project-local)
bgz config                          # show which config is active
```

Add `.bgz/` to your `.gitignore`.

## Migration

```bash
bgz migrate jira --from https://myco.atlassian.net --email me@co.com --token TOKEN --project PROJ
bgz migrate linear --token TOKEN --team ENG
bgz migrate shortcut --token TOKEN --project "My Project"
```

## Pricing

Starts at **$10/mo**. No free tier.

| Plan | Price | Projects | Team Members |
|------|-------|----------|-------------|
| Solo | $10/mo | 1 | 2 |
| Team | $30/mo | 3 | 10 |
| Scale | $75/mo | 10 | 50 |
| Enterprise | Custom | Unlimited | Unlimited |

## Documentation

- [Quickstart Guides](https://buggazi.com/docs/quickstart.html) — per-agent setup
- [Full Reference](https://buggazi.com/llms.txt) — all commands + API

## License

Proprietary — Tyga.Cloud Ltd. See [LICENSE](./LICENSE).
