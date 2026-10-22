# E36 — prediction

Write this before running anything. Topic: [capacity estimation](../../../../topics/capacity-estimation/index.html), section 05.

Setup: a table `events (id BIGINT AUTO_INCREMENT PRIMARY KEY, user_id BIGINT, payload VARBINARY(1000), created_at DATETIME(3), KEY (user_id))`.
A Node script with mysql2 inserts one 1 KB row per statement, autocommit,
`innodb_flush_log_at_trx_commit = 1`, for 60 s per configuration. Record writes
per second, p50 and p99, CPU, `Innodb_os_log_fsyncs` per second, and `iostat`.

1. Writes per second and p99 at 1, 8, 32 and 128 clients
   TODO
2. At which client count does throughput stop rising, and what is the bottleneck (CPU, disk, fsync)?
   TODO
3. Same at 32 clients with 100 rows per transaction: rows per second
   TODO
4. The number to put in "Primary chịu được" on the page, and how far it is from the page's default of 2,000
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
