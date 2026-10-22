# E56 — prediction

Write this before running anything. Topic: [Test strategy with a real MySQL](../../../../topics/test-strategy-real-db/index.html), section 05.

Setup: 400 tests touching the database, 10 tables, 4 Jest workers, one
`mysql:8.4` container started by Testcontainers in `globalSetup`, one database
per worker created from the real migrations.

1. Time from `start()` until the container accepts connections, cold image cache and warm
   TODO
2. Wall time of the whole suite with rollback, DELETE, TRUNCATE, a new database per test, and per-test unique data
   TODO
3. The same with `--tmpfs /var/lib/mysql`, `--innodb-flush-log-at-trx-commit=2`, `--skip-log-bin` (open question 45)
   TODO
4. Which strategy breaks tests for code that opens its own transaction, and how does the failure show up?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
