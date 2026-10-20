# E29 — prediction

Write this before running anything. Topic: [idempotency and retries](../../../../topics/idempotency-retries/index.html), section 05.

Setup: an HTTP endpoint behind a token bucket of 250 requests per second that
returns 503 for the first 2 seconds. A Node script starts 200 clients at once,
each calling it through `withRetry` (attempts 8, base 100 ms, cap 3.2 s), and logs
the time of every call.

For each strategy: total calls, time when the last client succeeds, peak calls per 100 ms, and how many clients give up.

1. Immediate retry (no wait)
   TODO
2. Exponential, no jitter
   TODO
3. Exponential, full jitter
   TODO
4. Exponential, equal jitter — fewer calls than full jitter, as the page's model says, or more, as the AWS article found?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
