// Buggazi webhook receiver — verifies the HMAC-SHA256 signature and prints events.
//
// Buggazi signs every delivery with your webhook secret:
//   X-Buggazi-Signature = HMAC-SHA256(rawBody, secret)  (hex)
// plus X-Buggazi-Event and X-Buggazi-Timestamp headers.
//
// The one rule that matters: verify against the RAW request bytes, not a
// re-serialized JSON.stringify(req.body) — re-serializing can reorder keys or
// change whitespace and break the signature. This receiver hashes the raw body.
//
// Run:
//   BUGGAZI_WEBHOOK_SECRET=your_secret node server.js
// Point Buggazi at it:
//   bgz settings webhooks set --url http://your-host:4000/hooks --events "bug:resolved"

const http = require('http');
const crypto = require('crypto');

const SECRET = process.env.BUGGAZI_WEBHOOK_SECRET;
const PORT = process.env.PORT || 4000;

if (!SECRET) {
  console.error('Set BUGGAZI_WEBHOOK_SECRET (the secret from `bgz settings webhooks set`).');
  process.exit(1);
}

function verify(rawBody, signature) {
  if (!signature) return false;
  const expected = crypto.createHmac('sha256', SECRET).update(rawBody).digest('hex');
  const a = Buffer.from(signature, 'hex');
  const b = Buffer.from(expected, 'hex');
  // Lengths must match before timingSafeEqual, or it throws.
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

const server = http.createServer((req, res) => {
  if (req.method !== 'POST' || req.url !== '/hooks') {
    res.writeHead(404).end();
    return;
  }

  const chunks = [];
  req.on('data', (c) => chunks.push(c));
  req.on('end', () => {
    const rawBody = Buffer.concat(chunks); // hash the exact bytes received
    const signature = req.headers['x-buggazi-signature'];

    if (!verify(rawBody, signature)) {
      console.warn('Rejected: bad or missing signature');
      res.writeHead(401).end('invalid signature');
      return;
    }

    const event = req.headers['x-buggazi-event'] || 'unknown';
    const payload = JSON.parse(rawBody.toString('utf8'));
    console.log(`[${new Date().toISOString()}] ${event}`, payload);

    // ── Do your thing here: retry a build, notify an agent, update a board… ──

    res.writeHead(200).end('ok');
  });
});

server.listen(PORT, () => console.log(`Listening for Buggazi webhooks on :${PORT}/hooks`));
