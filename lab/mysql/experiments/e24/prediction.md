# E24 — prediction

Write this before running anything. Topic: [concurrency control strategies](../../../../topics/concurrency-control-strategies/index.html), section 05.

Setup: `accounts (id BIGINT PRIMARY KEY, balance BIGINT NOT NULL, version INT NOT NULL DEFAULT 0)`
with one row `(42, 1000, 0)`, no `CHECK` constraint, and a `ledger (account_id, delta)` table.
A Node script using mysql2 sends 50 withdrawals of 30 at once with `Promise.all`
(pool size ≥ 50). Repeat each strategy 20 times, resetting the row between runs.

For each strategy: how many withdrawals succeed, the final `balance`, whether
`balance = 1000 − 30 × successes` holds, and whether `balance` ever goes negative.

1. Read, compute, overwrite (`SELECT`, then `UPDATE … SET balance = ?`)
   TODO
2. Check, then decrement (`SELECT`, check in app, then `SET balance = balance - 30`)
   TODO
3. Conditional `UPDATE … WHERE id = 42 AND balance >= 30`
   TODO
4. `SELECT … FOR UPDATE` in a transaction on one connection
   TODO
5. Version column, at most 3 attempts with jittered backoff: how many end in `ConcurrentModification`?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
