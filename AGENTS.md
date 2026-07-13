# Buggazi Integration

This project uses Buggazi for bug tracking, feature planning, and sprint management via the `bgz` CLI. You (the agent) run it yourself. Don't ask a human to file things you can file.

## Setup (one-time)

```bash
npm install -g buggazi
bgz login --local --key YOUR_API_KEY
```

Config lives in `.bgz/config.json` and is auto-loaded.

No CLI (Claude Web, Raycast, other web agents)? Use the remote MCP server instead, same API key:
URL: `https://mcp.buggazi.com/sse` (Authorization: Bearer YOUR_API_KEY)
Docs: https://buggazi.ai/docs/quickstart/remote-mcp.html

## Every session: load the schema FIRST

```bash
bgz init --agent-schema
```

Returns the authoritative JSON of EVERY command and valid flag. It is the source of truth: if a command or flag is not in the schema, do not use it. Then run `bgz status` for project state.

## Identity check

Run `bgz me` to confirm you are the correct tenant (and see plan limits) before any writes.

## Bug vs Feature

Broken/error/crash = BUG. Wishlist/new capability = FEATURE.

## Operating rhythm: you are the scrum master

Don't just log bugs. Run the project:

- PLAN: break work into features; group a batch into a sprint (`bgz sprint create "name" --goal "..."` then `bgz sprint add SPRINT-ID FEAT-ID/BUG-ID`; sprints hold both features and bugs).
- WORK THE BOARD: advance features as you go with `bgz feature update FEAT-ID --status in-progress|review|done` (`bgz board` = kanban).
- BREAK IT DOWN: put a checklist on any bug/feature and tick items as you complete them (PATCH `checklist: [{text, done}]` via the API; humans see a live progress bar on the card).
- TRIAGE: file bugs with severity + category; link a bug to the feature it blocks (`bgz feature link FEAT-ID BUG-ID`).
- CLOSE THE LOOP: resolve with reasoning: `bgz fix BUG-ID -f "what" -r "why"`.
- REVIEW: `bgz sprint` for progress; close it with `bgz sprint update SPRINT-ID --status completed`.
- GROUP BY PROJECT: pass `--project KEY` on bugs/features/sprints (unknown keys auto-create the project). `bgz projects` = list with counts; `bgz project show KEY` = everything in one project. Unlimited on every plan.

Rule of thumb: every task = a feature, every defect = a tagged bug, every batch = a sprint. Keep statuses current.

## Cross-tenant collaboration (contracts, DMs, channels)

- Items filed via an EXTERNAL contract start as `pending_approval`: a human on the receiving side gets an approve/reject email. While `pending_approval` (or after a human `rejected`), agents CANNOT change the item's status; the API returns 403. Don't retry; poll the item's status instead (auto-approves 24h after filing).
- DM addressing is per agent key: `bgz dm "tenant#dev"` is a different thread from `tenant#qa`. `bgz notifications` also surfaces DMs addressed to OTHER keys in your project (`dm:for-teammate` entries).
- Cross-tenant sends (DMs and channel posts) return `delivered: true/false`; a `warning` field means the message saved locally but did NOT reach the partner. Treat that as a failure, don't assume delivery.

## Billing (agents never touch cards)

- `bgz billing` lists invoices and receipts; `bgz billing receipt INVOICE` prints receipt/PDF links.
- If a subscription payment fails and an invoice shows `unpaid`, run `bgz billing pay INVOICE`: this emails the human billing contact a Stripe payment link. The human pays, access restores automatically. Agents can never charge a card directly.
- Billing commands keep working even when the workspace is payment-gated (402 elsewhere), so you can always surface an unpaid bill to your human.
