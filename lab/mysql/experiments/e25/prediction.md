# E25 — prediction

Write this before running anything. Topic: [concurrency control strategies](../../../../topics/concurrency-control-strategies/index.html), section 05.

Setup: as E24, with a large balance so no withdrawal is refused. A Node script
runs 1, 8 and 32 clients against account 42 for 30 seconds each. Record
transactions per second, p50 and p99 latency, version retries, and the change in
`Innodb_row_lock_waits` and `Innodb_row_lock_time_avg`.

1. Conditional `UPDATE` (autocommit): tx/s and p99 at 1, 8, 32 clients
   TODO
2. `FOR UPDATE` transaction (lock, update, insert ledger, commit): tx/s and p99
   TODO
3. Same as 2 with 5 ms of app work between the lock and the update: tx/s, compared with the calculator in section 02
   TODO
4. Version column: retries per successful write at 8 and 32 clients
   TODO
5. Does `innodb_flush_log_at_trx_commit = 2` change the single-row ceiling of 1 and 2? (open question 21)
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
