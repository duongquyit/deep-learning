# E17 — prediction

Write this before running anything. Topic: [buffer pool, redo and undo](../../../../topics/innodb-buffer-pool-redo-undo/index.html), section 05.

Setup: 50,000 single-row `INSERT`s into `orders`, autocommit, binary log off (as
in `lab.cnf`). Run from 1 client and from 16 parallel clients, with
`innodb_flush_log_at_trx_commit` = 1, 2 and 0.

1. Commits per second for each of the 6 runs.
   TODO
2. `Innodb_os_log_fsyncs` per run. With 16 clients and value 1, are there fewer fsyncs than commits? By how much?
   TODO
3. Which disk does your machine use, and what fsync latency do you expect from it?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
