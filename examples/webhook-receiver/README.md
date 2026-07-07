# Webhook receiver

A tiny, zero-dependency endpoint that verifies Buggazi's `X-Buggazi-Signature` and prints each event. Copy it, drop your logic in, done.

```bash
BUGGAZI_WEBHOOK_SECRET=your_secret node server.js
```

Then point Buggazi at it:

```bash
bgz settings webhooks set --url http://your-host:4000/hooks --events "bug:resolved,feature:created"
bgz settings webhooks test    # fires a signed test delivery
```

## How verification works

Every delivery carries three headers:

| Header | Value |
|--------|-------|
| `X-Buggazi-Signature` | `HMAC-SHA256(rawBody, secret)` as hex |
| `X-Buggazi-Event` | e.g. `bug:resolved` |
| `X-Buggazi-Timestamp` | ISO-8601 send time |

Hash the **raw request bytes** with your secret and compare (constant-time) against the signature header. Don't `JSON.stringify(req.body)` and hash that — re-serializing can change key order or whitespace and the signatures won't match. `server.js` hashes the exact bytes it received.

## Payload shape

```json
{
  "event": "bug:resolved",
  "timestamp": "2026-07-07T12:00:00.000Z",
  "tenantId": "…",
  "bug": { "id": "BUG-2026-0608-001", "…": "…" }
}
```

## Events you can subscribe to

`bug:created` · `bug:resolved` · `feature:created` · `sprint:updated` — or a prefix wildcard like `bug:*`, or `*` for everything.
