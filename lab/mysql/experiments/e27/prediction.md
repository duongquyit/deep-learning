# E27 — prediction

Write this before running anything. Topic: [idempotency and retries](../../../../topics/idempotency-retries/index.html), section 05.

Setup: `idempotency_keys` and the `transfer()` function from section 04 of the page,
with `doTransfer` slowed by `SELECT SLEEP(2)`. A Node script sends the same
`POST /transfers` (same key, same body) 2 times, then 10 times, with `Promise.all`.
Another session reads `performance_schema.data_locks` while the first request runs.

1. With 2 requests: how many ledger rows, and which status code does each request get?
   TODO
2. With 10 requests: same questions.
   TODO
3. While the first request runs: which rows does `data_locks` show for the waiting requests (index, `lock_mode`, `lock_status`)?
   TODO
4. Force the first request to fail and roll back (amount larger than the balance) with 3 concurrent requests: does a deadlock (1213) happen between the other two? (open question 23)
   TODO
5. Same key, different amount: what does the second request get?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
