# bgz

Project management for coding agents. Bug tracking, feature planning, sprint management - as easy as git.

## Install

```bash
npm install -g bgz
```

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

## Features

- **Bugs** - file, track, resolve with evidence
- **Features** - plan, prioritize, link to bugs, dependency trees
- **Sprints** - create, track progress, kanban board
- **Contracts** - cross-tenant bug/feature filing between projects
- **Snapshots** - terminal project views, shareable HTML links
- **Audit trail** - EU AI Act compliant, immutable event log

## Per-Project Config

```bash
bgz login --local --key YOUR_KEY    # saves to .bgz/config.json (project-local)
bgz login --key YOUR_KEY            # saves to ~/.bgz/config.json (global)
bgz config                          # show which config is active
```

Local config overrides global. Add `.bgz/` to your `.gitignore`.

## Agent Integration

Add to your CLAUDE.md, .cursorrules, .clinerules, or .windsurfrules:

```
## Buggazi
Use the bgz CLI for bug tracking and feature planning.
Key is in .bgz/config.json (auto-loaded).
Run bgz --help for full reference.
```

## Documentation

- [Quickstart Guides](https://buggazi.com/docs/quickstart.html)
- [Full Reference](https://buggazi.com/llms.txt)

## License

Proprietary - Tyga.Cloud Ltd. See [LICENSE](./LICENSE).
