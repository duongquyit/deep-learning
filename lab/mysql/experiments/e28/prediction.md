# E28 — prediction

Write this before running anything. Topic: [idempotency and retries](../../../../topics/idempotency-retries/index.html), section 05.

Setup: a consumer that adds points to `users` for each message. It reads
`CRASH_AT` (`pre`, `mid`, `post`) and calls `process.exit(1)` at that point.
Four variants: no marker; marker first in its own transaction; marker after in
its own transaction; marker and effect in one transaction. A script restarts the
consumer after each crash so the message is delivered again, then reads `points`.

For each variant and each crash point: how many times are the points added?

1. No marker — pre / post
   TODO
2. Marker first, own transaction — pre / mid / post
   TODO
3. Marker after, own transaction — pre / mid / post
   TODO
4. Marker and effect in one transaction — pre / post
   TODO
5. Does the result match the table in the widget on the page? Which cell, if any, differs?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
